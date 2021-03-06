
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
 ЗаполнитьПринадлежность();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ОпределитьРежимЗанесениеДанных(ТекущийОбъект.РежимСписка,Истина);
	ЗаполнитьКлассификаторы();
	ОдиночныйРежимРедактирования();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.РежимСписка Тогда
		ПроверяемыеРеквизиты.Добавить("НастройкиКлассификаторов.ЗначениеКлассификатора");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ТекущийОбъект.РежимСписка Тогда
		ТекущийОбъект.НастройкиКлассификаторов.Очистить();
		СтрокаДобавления 							= ТекущийОбъект.НастройкиКлассификаторов.Добавить();
		СтрокаДобавления.Классификатор 				= ТекущийОбъект.Классификатор;
		СтрокаДобавления.WebService 				= WebService;
		СтрокаДобавления.ЗначениеКлассификатора 	= "";
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КлассификаторПриИзменении(Элемент)
	СформироватьНаименование();
	ОпределитьРежимЗанесениеДанных();
КонецПроцедуры

&НаКлиенте
Процедура ПринадлежностьПриИзменении(Элемент)
	Объект.Классификатор = "";
	Элементы.Классификатор.СписокВыбора.Очистить();
	ЗаполнитьКлассификаторы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиКлассификаторов
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы
//Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьНаименование()

	Если ЗначениеЗаполнено(Объект.Принадлежность) И ЗначениеЗаполнено(Объект.Классификатор) И НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
		Объект.Наименование = Элементы.Принадлежность.ТекстРедактирования + " - " + Объект.Классификатор;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОпределитьРежимЗанесениеДанных(РежимРедактированияСписка = Неопределено,ОткрытиеФормы = Ложь)
	
	Если РежимРедактированияСписка <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ГруппаШапка","Видимость"							,НЕ РежимРедактированияСписка);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ГруппаНастройкиКлассификаторов","Видимость"		,РежимРедактированияСписка);
		Объект.РежимСписка 		= РежимРедактированияСписка;
	Иначе
		Если Объект.Классификатор.ВидОтображения = Перечисления.CRM_ВидыОтображенияКлассификаторов.ДополнительныйРеквизит Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ГруппаШапка","Видимость"						,Ложь);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ГруппаНастройкиКлассификаторов","Видимость"	,Истина);
			Объект.РежимСписка 	= Истина;
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ГруппаШапка","Видимость"						,Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ГруппаНастройкиКлассификаторов","Видимость"	,Ложь);
			Объект.РежимСписка 	= Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.РежимСписка И НЕ ОткрытиеФормы Тогда ПолучитьЗначенияКлассификатора(); КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗначенияКлассификатора()

	Объект.НастройкиКлассификаторов.Очистить();
	Запрос = Новый Запрос("Выбрать Ссылка КАК ЗначениеКлассификатора, &Классификатор Из Справочник.CRM_ЗначенияКлассификаторов Где Владелец = &Классификатор И НЕ ПометкаУдаления");
 	Запрос.УстановитьПараметр("Классификатор",Объект.Классификатор);
	Объект.НастройкиКлассификаторов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПринадлежность()

	СписокПринадлежность = Новый СписокЗначений;
	СписокПринадлежность.Добавить("Справочник.Партнеры"						,"Клиенты");
	СписокПринадлежность.Добавить("Справочник.вогТорговыеТочки"				,"Торговые точки");
	СписокПринадлежность.Добавить("Справочник.вогРаспределительныеЦентры"	,"Распределительные центры");
	СписокПринадлежность.Добавить("Справочник.вогЮридическиеЛица"			,"Юридические лица");
	
	Для каждого Таблица Из СписокПринадлежность Цикл
		Элементы.Принадлежность.СписокВыбора.Добавить(Таблица.Значение,Таблица.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКлассификаторы()

	Запрос = Новый запрос("ВЫБРАТЬ
	|	CRM_КлассификаторыПринадлежность.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовХарактеристик.CRM_Классификаторы.Принадлежность КАК CRM_КлассификаторыПринадлежность
	|ГДЕ
	|	CRM_КлассификаторыПринадлежность.ИмяТаблицы = &ИмяТаблицы");
	Запрос.УстановитьПараметр("ИмяТаблицы",Объект.Принадлежность);
	Элементы.Классификатор.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

&НаСервере
Процедура ОдиночныйРежимРедактирования()

	Если НЕ Объект.РежимСписка Тогда
		Если Объект.НастройкиКлассификаторов.Количество() = 1 Тогда
			ТекущаяСтрокаТЧ 	= Объект.НастройкиКлассификаторов[0];
			WebService 			= ТекущаяСтрокаТЧ.WebService;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти