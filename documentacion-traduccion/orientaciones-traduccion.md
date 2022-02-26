# Orientaciones para la traducción

En la primera parte de este documento se entregan algunas indicaciones generales para abordar la traducción. En la segunda, se enumeran algunos acuerdos respecto de cómo traduciremos ciertos términos, así como aquellos que mantendremos en inglés. A continuación, se indica qué hacer con los bloques de código. Finalmente, se entregan algunas indicaciones sobre aspectos de formato y ortográficos. 
A medida que avancemos en el proyecto iremos actualizando este documento para recoger los acuerdos que vayamos generando.

## I. Aspectos a tener en cuenta para la traducción del texto

__1. Al traducir lo que buscamos es generar una versión de cómo diríamos en español lo que en el capítulo está escrito en inglés.__ En algunos casos eso puede implicar alterar el orden de los elementos de una oración o agregar palabras que no estaban en el original. Lo importante es que la traducción "suene" lo más natural posible en español, respetando el contenido que se quiso transmitir en el original.

__2. La variedad dialectal del español que ocuparemos en la traducción es la de Latinoamérica__ (porque el posible público destinatario que la habla es más amplio). Trataremos de que sea una versión lo más neutra posible, por lo que:

* Evitaremos expresiones o usos locales/regionales, es decir, que no están extendidos en toda Latinoamérica.
* No utilizaremos el voseo (_vos/vosotros_). El libro está dirigido a una segunda persona, así que para cautelar la neutralidad la traduciremos como _tú_ (... _you'll learn_ > ... _aprenderás_).

__3. Género gramatical.__ A diferencia del inglés, el español tiene género gramatical (masculino, femenino y muy, pero muy pocos neutros). En general, como el libro está dirigido a un _tú_ y se habla de datos, variables y funciones, hay pocas situaciones en las que haya que tomar una decisión respecto de cómo manejar este tema; pero las hay. La primera opción será ajustar la redacción para evitar tener que asignar un género. Por ejemplo, _the students_ se podría traducir como _el estudiantado_. O _for data scientists_ como _para personas que trabajan en ciencia de datos_ o _para quienes hacen ciencia de datos_. Si el fragmento hace díficil elegir esta opción, entonces duplicaremos el género: _para científicos y científicas de datos_. 

__4. El español es una lengua menos repetitiva que el inglés.__ Como los verbos tienen marca de persona, género y número, tenemos la flexibilidad de poder omitir el sujeto, ya que por contexto se suele entender a qué nos estamos refiriendo.

Ejemplo:
> The first argument is the name of the data frame. The second and subsequent arguments are the expressions that filter the data frame.

Traducción:
> El primer argumento es el nombre del _data frame_. El segundo y los subsiguientes son las expresiones que filtran el _data frame_.

O incluso:
> El primer argumento es el nombre del _data frame_. El segundo y los subsiguientes son las expresiones para filtrarlo.

En todos los casos, hay que tratar de pensar cómo suena más "natural" en español y cómo queda más claro para quien lee.

__5. Hay regularidades que no siempre se cumplen.__ Por ejemplo, en inglés las palabras con función adjetiva se anteponen a los sustantivos (_missing values_, _help pages_, etc.), mientras que en español suele ser al revés: ponemos los adjetivos después del sustantivo: valores faltantes, páginas de ayuda, etc.
Sin embargo, hay casos en que en español la forma “no marcada”, es decir, la que nos suena más natural, es con el adjetivo al principio:

Ejemplo:
> ...this small example helps to understand... > ...este pequeño ejemplo ayuda a entender...

En general, ante dudas de este tipo, pensar en qué es lo que suena más "natural" en español.

__6. El español tiene más modos y tiempos verbales que el inglés__
Al traducir, por lo tanto, se debe priorizar la forma verbal que sea mejor para expresar el sentido del fragmento en español, no la que parezca ser literal del inglés.

Ejemplo: _That implies that you have the "best" model (according to some criteria); it doesn't imply that you have a good model and it certainly doesn't imply that the model is "true"_ > Esto implica que tienes el "mejor" modelo (de acuerdo a ciertos criterios); no implica que *tengas* un buen modelo y, ciertamente, no implica que el modelo *sea* "verdadero".

__7. Las expresiones idiomáticas no son traducibles de manera literal.__
En caso de que las hubiere (lo iremos descubriendo en el camino), hay que proponer una traducción que permita entender el sentido de ella.

Ejemplo:  
> _it’s raining cats and dogs_ > _está lloviendo a cántaros_

__8. Toma distancia para revisar.__ Cuando trabajamos mucho tiempo en un texto cuesta identificar errores de tipeo. Como sugerencia, una vez que termines la traducción del capítulo deja pasar algunas horas (o un día) antes de hacer la última lectura y enviarla. Eso hace más fácil que salten a la vista este tipo de detalles y permite que quienes hagan la revisión se concentren en la calidad de la traducción más que en correcciones ortotipográficas.

## II. Traducción (o no) de términos técnicos.
Hay términos técnicos que será necesario traducir y otros que no. El criterio suele estar en si existe una versión en español extendida (o entendible), o si se suele utilizar la versión original en inglés. En el caso de los últimos, hay que determinar qué género gramatical asignarle y si ofreceremos una traducción explicativa la primera vez que los utilicemos.
A medida que avancemos con la traducción, iremos discutiendo cada caso. A partir de lo que se acuerde, iremos completando las siguientes listas de términos.


#### Términos técnicos que se traducen
Pese a que hay términos que traduciremos al español, es importante que quien traduzca evalúe si corresponde mencionar de todos modos el término en inglés la primera vez. Por ejemplo, si bien _string_ es un término que tiene una traducción (_cadena de caracteres_) la primera vez que se menciona sería útil ofrecer también la versión en inglés, porque así resulta más claro por qué hay un paquete que se llama __stringr__, por ejemplo. En estos casos, la idea es traducir el texto y poner entre paréntesis el original en inglés.  En el caso de términos cuya traducción en español no está tan extendida, es necesario evaluar si corresponde agregar una pequeña explicación (por ejemplo, _mapping_ > "..._mapear, es decir, indicar qué variables se asignarán a cada eje_...".

| término en inglés | traducción a utilizar |
| ----------- | ----------- |
| app | aplicación |
| click (como verbo) | hacer clic |
| console | consola |
| dataset | conjunto de datos / set de datos |
| debug | depurar |
| deploy | ... |
| input | input (la palabra existe como anglicismo en español, no se traduce) |
| output | output (la palabra existe como anglicismo en español, no se traduce) |
| user interface | interfaz de usuario |


#### Términos técnicos que se mantienen
Estos términos irán _en cursiva_. De ser pertinente, se debe ofrecer una posible traducción al español, ya que en algunos casos permite entender mejor el concepto que está detrás.   

| no traducir    |
| ----------------------------|
| back end |
| front end |
| UI |


[Las Carpentries](https://github.com/Carpentries-ES/board/blob/master/Convenciones_Traduccion.md) tienen algunas convenciones que podemos ir revisando y ver si se adecuan al propósito de la traducción que estamos realizando.

## III. Traducción del código:

Experiencia anteriores de traducción nos han enseñado que es mejor traducir el código al final. Así que por el momento, los bloques de código no debes modificarlos, salvo los comentarios explicativos que contengan.

## IV. Aspectos de formato en RMarkdown

* Los nombres de los paquetes van __en negrita__.
* Los términos en inglés van _en cursiva_.
* **Es muy importante no modificar las referencias internas dentro de los archivos ni los anclajes de los títulos.**


## V. Aspectos de ortografía / gramática del español

* Ni los demostrativos ni el adverbio "solo" se tildan.
* Días y meses se escriben con minúscula en español.
* Los títulos llevan mayúscula solo en la palabra inicial (salvo que incluyan un nombre propio). No llevan punto final.
* Para consultar la forma convencional de una abreviatura en español, revisar este [enlace](http://www.rae.es/diccionario-panhispanico-de-dudas/apendices/abreviaturas). Hasta el momento ha aparecido _por ejemplo_ > _p. ej._.


