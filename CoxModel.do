use "/Users/meghanleehowat/Documents/STATA/data/Casas del Pollo (emprendedores)_WIDE.dta"
bysort codigo: gen counter=_N
drop if counter>1
save "/Users/meghanleehowat/Documents/STATA/data/Emprendedores.dta", replace

clear
use "/Users/meghanleehowat/Documents/STATA/data/CDPR - monthly sales and interview data.dta"  
keep codigo canal nombrecliente estado year month usd latitudvalue longitudvalue
merge m:1 codigo using "/Users/meghanleehowat/Documents/STATA/data/Emprendedores.dta", gen(_newmerge)
drop if _newmerge==2
drop _newmerge

merge m:1 codigo using "/Users/meghanleehowat/Documents/STATA/data/BuffersCodigo.dta", gen(_newmerge)
drop if _newmerge==2
drop _newmerge

gen date=ym(year,month)
sort codigo date
by codigo: gen activo=_n
by codigo: gen failtime=activo==_N
replace failtime=0 if estado=="ACTIVO"
egen date0=group(date)

stset date0, id(codigo) failure(failtime==1)

sts graph, ci ///
graphregion(color(white)) bgcolor(white) ///
ytitle("Survival probability") ///
xtitle("Months after market entry") ///
title("Kaplan-Meier Survival Curve")

* Region
gen central=(departamento=="GUATEMALA")
gen occidental=(departamento=="CHIMALTENANGO" | departamento=="ESCUINTLA" | ///
departamento=="HUEHUETENANGO" | departamento=="QUETZALTENANGO" | departamento=="QUICHE" | ///
departamento=="RETALHULEU" | departamento=="SACATEPEQUEZ" | departamento=="SAN MARCOS" | ///
departamento=="SANTA ROSA" | departamento=="SOLOLÁ" | departamento=="SUCHITEPÉQUEZ" | ///
departamento=="TOTONICAPÁN")
gen oriental=(departamento=="ALTA VERAPAZ" | departamento=="BAJA VERAPAZ" | ///
departamento=="CHIQUIMULA" | departamento=="EL PROGRESO" | departamento=="IZABAL" | ///
departamento=="JALAPA" | departamento=="JUTIAPA" | departamento=="PETÉN" | departamento=="ZACAPA")
gen region=1 if central==1
replace region=2 if occidental==1
replace region=3 if oriental==1

* Socio-demographic characteristics 
gen age=_edad
gen agesq=_edad^2
gen female=genero=="Mujer"
gen education_none=_educacion== "Ninguno"
gen education_elementary=(_educacion=="Preprimaria" | _educacion=="Primaria")
gen education_higher=(_educacion=="Doctorado" | _educacion=="Licenciatura" | _educacion=="Maestría")
gen education_highschool=_educacion=="Diversificado"
gen education_technical=(_educacion== "Certificación técnica (ej. INTECAP)" | _educacion=="Técnico universitario")
gen previnbusiness=_ocup_previa=="Tenía otro negocio propio "
gen married=_edocivil=="Casada(o)"
gen children=_hijos
gen hhsize=_miembros
gen floor=_piso=="Ladrillo cerámico"
egen occupation_category=group(_ocup_previa)
egen motives_category=group(motivos)

* Franchise operations
gen lnusd=log(usd)
gen totalhours= horas_lv + sab + dom

* Technology
gen computer=computadora=="Si"
gen smartphone=celular=="Sí"

* Knowledge and know how
egen financial_management=group(contabilidad)
gen keepsrecords=financial_management==2
gen recibido = recibido_capacitacion=="Si"
gen numberofbranches=_numerocdp

* Operational costs
gen rented=local=="Rentado"
gen loan=prestamo_vigente=="Si"
gen paid_workers=_sueldo
gen family_workers=_miembros_trabajando
gen loginv=log(inv)

* Regression tables
stcox lnusd i.region, robust 
est store reg1
stcox lnusd age i.region, robust 
est store reg2
stcox lnusd age education_technical i.region, robust 
est store reg3
stcox lnusd age education_technical rented i.region, robust 
est store reg4
stcox lnusd age education_technical rented keepsrecords i.region, robust 
est store reg5
stcox lnusd age education_technical rented keepsrecords female i.region, robust 
est store reg6

esttab reg1 reg2 reg3 reg4 reg5 reg6, b se drop(*.region) nomtitle stats(N, fmt(0))


/* 
OTHER AVAILABLE VARIABLES:

married children hhsize floor occupation_category motives_category computer smartphone keepsrecords recibido numberofbranches rented loan paid_workers family_workers 
*/
