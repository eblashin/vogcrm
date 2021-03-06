
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЭтоАдресВременногоХранилища(Параметры.АдресТекущейСтроки) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ТекущиеДанныеЭлемента = ПолучитьИзВременногоХранилища(Параметры.АдресТекущейСтроки);
	
	Имя = ТекущиеДанныеЭлемента.Имя;
	ИД	= ТекущиеДанныеЭлемента.ИД;
	
	Если ТекущиеДанныеЭлемента.Настройки <> "" Тогда
		Настройки 		= ЗначениеИзСтрокиВнутр(ТекущиеДанныеЭлемента.Настройки);
		ТекстДействия 	= Настройки.ТекстДействия;
		ШаблонКода		= Настройки.Шаблон;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Заголовок = "Редактирование обработчика: " + Имя;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ШаблонКодаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ТекстДействия = ПолучитьЗначениеРеквизита(ВыбранноеЗначение,"ПроизволныйКод");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьКод(Команда)
	
	СтруктураПолей = вогОбщегоНазначенияВызовСервера.ПолучитьСтруктуруПолейДляВыполненияПроизвольногоКода();
	СтруктураПолей.Код						= ТекстДействия;
	СтруктураПолей.ЗаголовокСобытия			= "Обработка на сервере";
	СтруктураПолей.Отказ					= Ложь;
	СтруктураПолей.ТолькоПроверка			= Истина;
	СтруктураПолей.ВыводитьСообщения		= Истина;
	СтруктураПолей.ВыполнятьПроизвольныйКод	= Истина;
	
	вогОбщегоНазначенияВызовСервера.ВыполнитьПроизвольныйКод(СтруктураПолей);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	АдресСтрокиХранилища = ПодготовитьДанныеНастройкиОбработки();
	Закрыть(АдресСтрокиХранилища);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьДанныеНастройкиОбработки()
	
	ИсходящаяСтруктура = Новый Структура;
	ИсходящаяСтруктура.Вставить("ИД",ИД);
	ИсходящаяСтруктура.Вставить("Имя",Имя);
	ИсходящаяСтруктура.Вставить("Настройки",ЗначениеВСтрокуВнутр(Новый Структура("Шаблон,ТекстДействия",ШаблонКода,ТекстДействия)));
	
	АдресСтроки = ПоместитьВоВременноеХранилище(ИсходящаяСтруктура);
	Возврат АдресСтроки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизита(Ссылка,ИмяРеквизита)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка,ИмяРеквизита,Истина);
КонецФункции

#КонецОбласти