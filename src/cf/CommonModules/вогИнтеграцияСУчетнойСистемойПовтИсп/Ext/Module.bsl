
#Область ПрограммныйИнтерфейс

Функция ПолучитьПрокси(СообщениеОбОшибке = "") Экспорт
	
	Пользователь = Константы.вогЛогинУС.Получить();
	Пароль       = Константы.вогПарольУС.Получить();
	Адрес 		 = Константы.вогАдресВебСервисовУС.Получить();
	
	Если ПустаяСтрока(Адрес) Тогда
		СообщениеОбОшибке = НСтр("ru='По указанному адресу сервис недоступен.';en='The service is not available.'");
		Возврат Неопределено;
	Конецесли;
	
	Адрес = СокрЛП(Адрес) + "/ws/CRM_DataExchange?wsdl";
	
	Попытка
		Определения = Новый WSОпределения(Адрес, Пользователь, Пароль);
		Прокси = Новый WSПрокси(Определения, "http://www.rarus.ru/CRMDataExchange", "CRM_DataExchange", "CRM_DataExchangeSoap");
		Прокси.Пользователь = Пользователь;
		Прокси.Пароль = Пароль;
		Возврат Прокси;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Описание = Инфо.Причина.Описание;
		Если Найти(Описание, "При создании описания сервиса произошла ошибка")
			ИЛИ Найти(Описание, "Ошибка HTTP") Тогда
			СообщениеОбОшибке = НСтр("ru='По указанному адресу сервис недоступен.';en='The service is not available.'");
		Иначе
			СообщениеОбОшибке = Инфо.Причина.Описание;
		КонецЕсли;
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции // ПолучитьПрокси()

#КонецОбласти