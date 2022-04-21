#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "ejs.h"

int main (void){
	/* Acá pueden realizar sus propias pruebas 
	void  strArrayAddLast(str_array_t* a, char* data)*/

	//-----------str_array_t* strArrayNew(uint8_t capacity)-----------

	str_array_t* new = strArrayNew(4);
	printf("size tiene que ser cero : %d, capacity tiene que ser 4: %d\n", new->size, new->capacity);

	//--------uint8_t  strArrayGetSize(str_array_t* a);----------
	char* a = "Holanda";
	char* b = "Que";
	char* c = "Acelga";
	strArrayAddLast(new, a);
	strArrayAddLast(new, b);
	strArrayAddLast(new, c);
	printf("size de data es: %ld\n", sizeof(new->data));
	printf("size tiene que ser 3: %d\n", strArrayGetSize(new));
	
	//------------char* strArrayGet(str_array_t* a, uint8_t i)-------
	printf("el 2do elemento tiene que ser Acelga: %s\n", strArrayGet(new, 2));
	printf("el 1er elemento tiene que ser Que: %s\n", strArrayGet(new, 1));
	printf("en la posicion cero tiene que estar Holanda: %s\n", strArrayGet(new, 0));

	//-----------void  strArrayDelete(str_array_t* a);------
	printf("Saque el elemento: %s\n", strArrayRemove(new, 1));
	printf("Ahora el size tiene que ser 2: %d\n", new->size);
	printf("Ahora en la 0 posicion tiene que estar Holanda: %s\n", strArrayGet(new, 0));
	printf("Ahora en la 1 posicion tiene que estar Acelga: %s\n", strArrayGet(new, 1));
	printf("En la 2da posicion tiene que haber un null: %s\n", strArrayGet(new, 2));
	printf("Saque el elemento: %s\n", strArrayRemove(new, 0));
	printf("Ahora en la 0 posicion tiene que estar Acelga: %s\n", strArrayGet(new, 0));
	printf("Ahora en la 1 posicion tiene que estar null: %s\n", strArrayGet(new, 1));
	printf("Ahora el size tiene que ser 1: %d\n", strArrayGetSize(new));
	
	//--------void  strArrayDelete(str_array_t* a)-------------

	strArrayDelete(new);
	printf("Mande un strArrayDelete\n");


	return 0;    
}


