#!/bin/sh

#Compruebo que me pasan solo el fichero como parametro
if [ $# -ne 1 ];then
	echo "Entrada errónea. Indicar sólo el fichero con los datos"
	exit 1
fi
#Compruebo que exista el fichero
if (! [ -f ./$1 ] ); then
	echo "Error. El fichero no existe"
	exit 1
fi
#Aplico mi filtro según las condiciones indicadas, los errores van a null
awk '
{
if (NR==1){
	first=1
	num_valores=0
	sum=0
	max=0
}
while($0~/^#/){
	getline
}
if (NF==1){
	if (num_valores){
		media=sum/num_valores
		printf media " "
		print max	
	}else if(!first){
		print "0 0"
	}
	num_valores=0
	sum=0
	max=0
	first=0
	printf tolower($0)
}else if(NF==4){
	sum=sum+$3
	num_valores=num_valores+1
	if ($4>max){
		max=$4
	}
}
}
END{if (num_valores){
		media=sum/num_valores
		printf media " "
		print max	
	}else{
		print "0 0"
	}
}' $1 2>/dev/null
#Compruebo la salida de awk y si es erronea, salgo con error
exit_awk=$(echo $?)
if [ $exit_awk -ne 0 ]; then
	echo
	echo "Error en el fichero de datos, puede que no se procesara correctamente"
	exit 1
fi
exit 0
