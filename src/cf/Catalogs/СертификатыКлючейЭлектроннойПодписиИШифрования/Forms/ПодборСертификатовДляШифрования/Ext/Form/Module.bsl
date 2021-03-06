#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебный.УстановитьУсловноеОформлениеСпискаСертификатов(Список);
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Организация", Организация);
	
	ЗакрыватьПриВыборе = Ложь;
	
	Если Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ДополнитьЗапросСпискаСертификатов(
			Список.ТекстЗапроса);
	Иначе
		Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "&ДополнительноеУсловие", "ИСТИНА");
	КонецЕсли;
	
	ГруппаПользователейПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования")
	   И Параметр.Свойство("ЭтоНовый") Тогда
		
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Источник;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаПользователейИспользованиеПриИзменении(Элемент)
	
	ГруппаПользователейПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПользователейПриИзменении(Элемент)
	
	ГруппаПользователейПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Не Копирование Тогда
		ПараметрыСоздания = Новый Структура;
		ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
		ПараметрыСоздания.Вставить("Организация",   Организация);
		
		ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификатПослеВыбораНазначения(
			"ТолькоДляШифрования", ПараметрыСоздания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Добавить(Команда)
	
	Элементы.Список.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзФайла(Команда)
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
	ПараметрыСоздания.Вставить("Организация",   Организация);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификатТолькоДляШифрованияИзФайла(ПараметрыСоздания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ГруппаПользователейПриИзмененииНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ГруппаПользователей", ГруппаПользователей, ГруппаПользователейИспользование);
	
КонецПроцедуры

#КонецОбласти
