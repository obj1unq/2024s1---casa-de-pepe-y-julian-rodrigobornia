
object casaDePepeYJulian {
	var property porcentajeViveres  = 0
	var property montoReparaciones  = 0
	var cuentaActual = cuentaCorriente
	var estrategiaDeAhorro = full

	method cuentaActual(_cuentaActual) { //setter
		cuentaActual = _cuentaActual
	}
	
	method estrategiaDeAhorro(_estrategiaDeAhorro) {
		estrategiaDeAhorro = _estrategiaDeAhorro
	}
	
	method hayViveresSuficientes(){
		return porcentajeViveres > 40
	}
	method hayQueHacerReparaciones() { //booleano
		return montoReparaciones >= 0
	}
	method estaEnOrden() { //booleano
		return self.hayViveresSuficientes() 
				and !self.hayQueHacerReparaciones()
	}
	method romperAlgo(monto) {
		montoReparaciones += monto
	}
	method hacerMantenimiento() {
		estrategiaDeAhorro.hacerMantenimientoPara(self)
	}
	
	method comprarViveres() {
		self.gastar(estrategiaDeAhorro.comprarViveresPara(self))
		self.aumentarViveres()
	}
	
	method gastar(monto) {
		cuentaActual.extraer(monto)
	}
	
	method porcentajeAComprar() {
		return estrategiaDeAhorro.porcentajeAComprarPara(self)
	}
	
	method aumentarViveres() {
		porcentajeViveres += self.porcentajeAComprar()
	}
	
	method hacerReparaciones() {
		self.gastar(self.montoReparaciones())
		montoReparaciones = 0
	}
	
	method saldoDespuesDeReparaciones() {
		return cuentaActual.saldo() - self.montoReparaciones()
	}
	
}
object cuentaCorriente{
	var property saldo = 0
	
	method depositar(monto){
		saldo += monto
	}
	method extraer(monto){
		saldo -= monto
	}
}

object cuentaConGastos{
	var property saldo = 0
	var property costoOperacion = 0
	
	method depositar(monto){
		saldo += monto - costoOperacion
	}
	method extraer(monto){
		saldo -= monto
	}
}
object cuentaCombinada{
	const cuentaPrimaria = cuentaConGastos
	const cuentaSecundaria = cuentaCorriente
	
	method saldo() {
		return cuentaPrimaria.saldo() + cuentaSecundaria.saldo()
	}
	method depositar(monto) {
		cuentaPrimaria.depositar(monto)
	}
	
	method extraer(monto) {
		if (monto <= cuentaPrimaria.saldo()) {
			cuentaPrimaria.extraer(monto)
		} else {
			cuentaSecundaria.extraer(monto)
		}
	}
}
object minimoEIndispensable {
	var calidad 
	
	method calidad(_calidad) {
		calidad = _calidad
	}
	
	method hacerMantenimientoPara(casa) {
		if (!casa.hayViveresSuficientes()) {
			casa.comprarViveres()
		}
	}
	
	method porcentajeAComprarPara(casa) {
		return 40 - casa.porcentajeViveres()
	}
	
	method comprarViveresPara(casa) {
		return self.porcentajeAComprarPara(casa) * calidad
	}
}
object full {
	const calidad = 5
	
	method hacerMantenimientoPara(casa) {
		casa.comprarViveres()
		self.reparaA(casa)
	}
	
	method porcentajeAComprarPara(casa) {
		return if (casa.estaEnOrden()) {
			100 - casa.porcentajeViveres()
		} else {
			40
		}
	}
	
	method comprarViveresPara(casa) {
		return self.porcentajeAComprarPara(casa) * calidad
	}
	
	method reparaA(casa) {
		if (casa.saldoDespuesDeReparaciones() >= 1000) {
			casa.hacerReparaciones()
		}
	}
}
