///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Разбирает представление контактной информации и возвращает строку XML со значениями полей.
//
//  Параметры:
//      Текст        - Строка - Представление контактной информации
//      ОжидаемыйТип - СправочникСсылка.ВидыКонтактнойИнформации, ПеречислениеСсылка.ТипыКонтактнойИнформации - для
//                     контроля типов.
//
//  Возвращаемое значение:
//      Строка - JSON
//
Функция КонтактнаяИнформацияПоПредставлению(Знач Текст, Знач ОжидаемыйВид, РазбиватьНаПоля = Истина) Экспорт // +++ Кулаков П.Л. CRM-839
	Возврат УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Текст, ОжидаемыйВид, РазбиватьНаПоля); // +++ Кулаков П.Л. CRM-839
КонецФункции

// Возвращает строку состава из значения контактной информации.
//
//  Параметры:
//      XMLДанные - Строка - XML данных контактной информации.
//
//  Возвращаемое значение:
//      Строка - содержимое
//      Неопределено - если значение состава сложного типа.
//
Функция СтрокаСоставаКонтактнойИнформации(Знач XMLДанные) Экспорт;
	Возврат УправлениеКонтактнойИнформациейСлужебный.СтрокаСоставаКонтактнойИнформации(XMLДанные);
КонецФункции

// Преобразует все входящие форматы контактной информации в XML.
//
Функция ПривестиКонтактнуюИнформациюXML(Знач Данные) Экспорт
	Возврат УправлениеКонтактнойИнформациейСлужебный.ПривестиКонтактнуюИнформациюXML(Данные);
КонецФункции

// Возвращает найденную ссылку или создает новую страну мира и возвращает ссылку на нее.
//
Функция СтранаМираПоДаннымКлассификатора(Знач КодСтраны) Экспорт
	
	Возврат УправлениеКонтактнойИнформацией.СтранаМираПоКодуИлиНаименованию(КодСтраны);
	
КонецФункции

// Заполняет коллекцию ссылками на найденные или созданные страны мира.
//
Процедура КоллекцияСтранМираПоДаннымКлассификатора(Коллекция) Экспорт
	
	Для Каждого КлючЗначение Из Коллекция Цикл
		Коллекция[КлючЗначение.Ключ] =  УправлениеКонтактнойИнформацией.СтранаМираПоКодуИлиНаименованию(КлючЗначение.Значение.Код);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет список вариантов адреса при автоподборе по введенному пользователем тексту.
//
Процедура АвтоподборАдреса(Знач Текст, ДанныеВыбора) Экспорт
	
	УправлениеКонтактнойИнформациейСлужебный.АвтоподборАдреса(Текст, ДанныеВыбора);
	
КонецПроцедуры

// Преобразует входящие форматы контактной информации во внутренний формат JSON.
//
// Параметры:
//    КонтактнаяИнформация - Строка - строка в формате XML. Структура XML-документа соответствует XDTO-пакету КонтактнаяИнформация
//                                    или Адрес (для адресов содержащих поля с национальной спецификой).
//                                    Если передана строка во внутреннем формате JSON, то возвращаемое значение будет
//                                    полностью совпадать с ней.
//                         - см. УправлениеКонтактнойИнформациейКлиентСервер.СтруктураКонтактнойИнформацииПоТипу.
//                                       см. РаботаСАдресами.ПоляАдреса (для адресов содержащих поля с национальной спецификой),
//                                       см. РаботаСАдресамиКлиентСервер.СтруктураКонтактнойИнформацииПоТипу
//                                       (для других типов контактной информации содержащих поля с национальной спецификой).
//    ОжидаемыйВид - СправочникСсылка.ВидыКонтактнойИнформации, ПеречислениеСсылка.ТипыКонтактнойИнформации -
//                   используется для определения типа контактной информации, если его невозможно определить из
//                   переданной контактной информации в параметре КонтактнаяИнформация.
//
// Возвращаемое значение:
//     Строка - контактная информация во внутреннем формате JSON.
//              Поля и их описание см. УправлениеКонтактнойИнформациейКлиентСервер.ОписаниеНовойКонтактнойИнформации.
//              Дополнительные поля для конфигурации с поддержкой национальной специфики см. РаботаСАдресамиКлиентСервер.ОписаниеНовойКонтактнойИнформации
//
Функция КонтактнаяИнформацияВJSON(Знач XMLДанные, Знач ОжидаемыйВид = Неопределено) Экспорт
	
	Возврат УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВJSON(XMLДанные, ОжидаемыйВид);
	
КонецФункции

#КонецОбласти

#Область ОбратнаяСовместимость

// Возвращает список значений. Преобразует строку полей в список значений.
//
// Параметры:
//    СтрокаПолей - Строка - строка полей.
//
// Возвращаемое значение:
//    СписокЗначений - список значений полей.
//
Функция ПреобразоватьСтрокуВСписокПолей(СтрокаПолей) Экспорт
	
	// XML сериализацию преобразовывать не надо.
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(СтрокаПолей) Тогда
		Возврат СтрокаПолей;
	КонецЕсли;
	
	Результат = Новый СписокЗначений;
	
	СтруктураЗначенийПолей = СтруктураЗначенийПолей(СтрокаПолей);
	Для каждого ЗначениеПоля Из СтруктураЗначенийПолей Цикл
		Результат.Добавить(ЗначениеПоля.Значение, ЗначениеПоля.Ключ);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Получает сокращение географического названия объекта.
//
// Параметры:
//    ГеографическоеНазвание - Строка - географическое название объекта.
//
// Возвращаемое значение:
//     Строка - пустая строка или последнее слово в географическом названии.
//
Функция АдресноеСокращение(Знач ГеографическоеНазвание)
	
	Сокращение = "";
	МассивСлов = СтрРазделить(ГеографическоеНазвание, " ", Ложь);
	Если МассивСлов.Количество() > 1 Тогда
		Сокращение = МассивСлов[МассивСлов.Количество() - 1];
	КонецЕсли;
	
	Возврат Сокращение;
	
КонецФункции

// Преобразует строку полей вида ключ = значение в структуру.
//
//  Параметры:
//      СтрокаПолей             - Строка - строка полей с данными в виде ключ = значение.
//      ВидКонтактнойИнформации - СправочникСсылка.ВидыКонтактнойИнформации - для определения состава незаполненных
//                                                                            полей.
//
//  Возвращаемое значение:
//      Структура - значения полей.
//
Функция СтруктураЗначенийПолей(СтрокаПолей, ВидКонтактнойИнформации = Неопределено) Экспорт
	
	Если ВидКонтактнойИнформации = Неопределено Тогда
		Результат = Новый Структура;
	Иначе
		Результат = РаботаСАдресамиКлиентСервер.СтруктураКонтактнойИнформацииПоТипу(ВидКонтактнойИнформации.Тип);
	КонецЕсли;
	
	ПоследнийЭлемент = Неопределено;
	
	Для Итерация = 1 По СтрЧислоСтрок(СтрокаПолей) Цикл
		ПолученнаяСтрока = СтрПолучитьСтроку(СтрокаПолей, Итерация);
		Если СтрНачинаетсяС(ПолученнаяСтрока, Символы.Таб) Тогда
			Если Результат.Количество() > 0 Тогда
				Результат.Вставить(ПоследнийЭлемент, Результат[ПоследнийЭлемент] + Символы.ПС + Сред(ПолученнаяСтрока, 2));
			КонецЕсли;
		Иначе
			ПозицияСимвола = СтрНайти(ПолученнаяСтрока, "=");
			Если ПозицияСимвола <> 0 Тогда
				НазваниеПоля = Лев(ПолученнаяСтрока, ПозицияСимвола - 1);
				ЗначениеПоля = Сред(ПолученнаяСтрока, ПозицияСимвола + 1);
				Если НазваниеПоля = "Регион" Или НазваниеПоля = "Район" Или НазваниеПоля = "Город" 
					Или НазваниеПоля = "НаселенныйПункт" Или НазваниеПоля = "Улица" Тогда
					Если СтрНайти(СтрокаПолей, НазваниеПоля + "Сокращение") = 0 Тогда
						Результат.Вставить(НазваниеПоля + "Сокращение", АдресноеСокращение(ЗначениеПоля));
					КонецЕсли;
				КонецЕсли;
				Результат.Вставить(НазваниеПоля, ЗначениеПоля);
				ПоследнийЭлемент = НазваниеПоля;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Возвращает список идентификаторов строк доступных для копирования в текущий адресов.
// 
Функция ДоступныеДляКопированияАдреса(Знач ЗначенияПолейДляАнализа, Знач ВидАдреса) Экспорт
	
	Возврат УправлениеКонтактнойИнформациейСлужебный.ДоступныеДляКопированияАдреса(ЗначенияПолейДляАнализа, ВидАдреса);
	
КонецФункции

#КонецОбласти
