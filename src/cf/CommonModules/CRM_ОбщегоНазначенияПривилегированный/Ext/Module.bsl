
// Проверка на возможность изменения установленной валюты учета.
//
Функция ОтказИзменитьВалютаУчета() Экспорт
	
	ЕстьДвижения = Ложь;
	
	СписокРегистров = Новый СписокЗначений;
	СписокРегистров.Добавить("РасчетыСПокупателями");
	СписокРегистров.Добавить("CRM_Продажи");
	СписокРегистров.Добавить("CRM_Предложения");
	
	СчетчикРегистровНакопления = 0;
	Запрос = Новый Запрос;
	Для каждого РегистрНакопления Из СписокРегистров Цикл
		
		Запрос.Текст = Запрос.Текст + 
			?(Запрос.Текст = "",
				"ВЫБРАТЬ ПЕРВЫЕ 1", 
				" 
				|
				|ОБЪЕДИНИТЬ ВСЕ 
				|
				|ВЫБРАТЬ ПЕРВЫЕ 1 ") + "
				|
				|	РегистрНакопления" + РегистрНакопления.Значение + ".Организация
				|ИЗ
				|	РегистрНакопления." + РегистрНакопления.Значение + " КАК РегистрНакопления" + РегистрНакопления.Значение;
		
		СчетчикРегистровНакопления = СчетчикРегистровНакопления + 1;
		
		Если СчетчикРегистровНакопления > 3 Тогда
			СчетчикРегистровНакопления = 0;
			Попытка
				РезультатЗапроса = Запрос.Выполнить();
				ЕстьДвижения = НЕ РезультатЗапроса.Пустой();
			Исключение
				
			КонецПопытки;
			
			Если ЕстьДвижения Тогда
				Прервать;
			КонецЕсли; 
			Запрос.Текст = "";
		КонецЕсли;
		
	КонецЦикла;
	
	Если СчетчикРегистровНакопления > 0 Тогда
		Попытка
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				ЕстьДвижения = Истина;
			КонецЕсли;
		Исключение
			
		КонецПопытки;
	КонецЕсли;
	
	Если ЕстьДвижения Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции // ОтказИзменитьВалютаУчета()

Процедура ПерезаписатьСсылкуНаОбъект(СсылкаНаОбъект) Экспорт
	
	ОбъектЮрЛица = СсылкаНаОбъект.ПолучитьОбъект();
	ОбъектЮрЛица.Записать();

КонецПроцедуры
