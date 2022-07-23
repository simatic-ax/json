# Changelog

## January 2022-02-02
0.0.1 First draft

## February 2022-02-28

**Version:** 0.0.5 

Deserializer and Serializer are shipped together. Including documentation

**Version:** 0.0.6 

JSonDocument.CleanBuffer() method added. [Issue](https://github.com/simatic-ax/Json/issues/12)

## March 2022-03-14

**Version:** 0.1.0 

* Fixing issue Now also nested objects will be serialized correctly
* JSonDocument and JsonObject implementing IJsonContainerElement now
* All public classes/types are FINAL, so they cant be inherited
* AddElement supports the create pattern now. `doc.AddElement(a).AddElement(b)`
  

## June 2022-06-24

**Version:** 0.2.0 

* Depends now on System.Math 1.1.13 Update dependencies 

Version 1.0.0