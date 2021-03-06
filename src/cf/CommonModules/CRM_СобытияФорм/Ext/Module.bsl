////////////////////////////////////////////////////////////////////////////////
// Содержит события форм, вызываемые на сервере
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
//  Форма					- УправляемаяФорма - форма, из обработчика события которой происходит вызов процедуры.
//  Отказ					- Булево - признак отказа от создания формы.
//  СтандартнаяОбработка	- Булево - признак выполнения стандартной (системной) обработки события
//  ДополнительныеПараметры	- Структура - дополнительные параметры
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры = Неопределено) Экспорт
	
	
	CRM_МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(Форма.ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
//	Форма					- УправляемаяФорма - форма, из обработчика события которой происходит вызов процедуры.
//	ТекущийОбъект			- Объект - объект, который будет прочитан.
//	ДополнительныеПараметры - Структура - дополнительные параметры
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект, ДополнительныеПараметры = Неопределено) Экспорт
	
	
	CRM_МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - форма, из обработчика события которой происходит вызов процедуры.
//	см. справочную информацию по событиям управляемой формы.
//
Процедура ПередЗаписьюНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи)Экспорт
	
	// +CRM
	CRM_МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	// -CRM
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - форма, из обработчика события которой происходит вызов процедуры.
//	см. справочную информацию по событиям управляемой формы.
//
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи)Экспорт
	
	CRM_МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти
