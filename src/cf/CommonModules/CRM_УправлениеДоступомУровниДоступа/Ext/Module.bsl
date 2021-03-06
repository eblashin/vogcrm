// +CRM не переносить в объединенные решения

////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ УПРАВЛЕНИЯ ДОСТУПОМ - УРОВНИ ДОСТУПА

// Получение дступных пользователю уровней доступа 
// при записи пользователя обновляем парметр сеанса "CRM_ПодразделениеТекущегоПользователя".
//
// Параметры:
//	Пользователь - СправочникСсылка.Пользователи
//
// Результат: массив
//
Функция ПолучитьДоступныеУровниДоступа(Пользователь = Неопределено) Экспорт
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Возврат Новый Массив();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда
		Пользователь = Пользователи.ТекущийПользователь(); 
	КонецЕсли; 
	
	//Если НЕ ЗначениеЗаполнено(Пользователь.CRM_УровеньДоступа) Тогда
	//	МассивСсылок = Новый Массив();
	//	МассивСсылок.Добавить(Справочники.CRM_УровниДоступа.ПустаяСсылка());
	//	Возврат МассивСсылок;
	//КонецЕсли;
	
	//Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("УровеньДоступа", Пользователь.CRM_УровеньДоступа);
	//Запрос.Текст = "ВЫБРАТЬ
	//|	CRM_УровниДоступа.Ссылка
	//|ИЗ
	//|	Справочник.CRM_УровниДоступа КАК CRM_УровниДоступа
	//|ГДЕ
	//|	НЕ CRM_УровниДоступа.ПометкаУдаления
	//|	И CRM_УровниДоступа.Ссылка В ИЕРАРХИИ(&УровеньДоступа)";
	//Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	CRM_УровниДоступаСостав.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.CRM_УровниДоступа.Состав КАК CRM_УровниДоступаСостав
		|ГДЕ
		|	CRM_УровниДоступаСостав.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
		
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");	
	
КонецФункции // ПолучитьДоступныеУровниДоступа

// Заполняет параметр сеанса для механизма ограничений доступа к клиентам.
// 
Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса) Экспорт
	
	ИспользоватьОграниченияДоступаCRM = Константы.CRM_ИспользоватьОграниченияДоступа.Получить();
	
	Если ИменаПараметровСеанса.Найти("CRM_ИспользоватьОграниченияДоступаCRM") <> Неопределено Тогда
		ПараметрыСеанса.CRM_ИспользоватьОграниченияДоступаCRM = ИспользоватьОграниченияДоступаCRM;
	КонецЕсли;
	
	// Заполним доступные пользователю уровни доступа
	Если ИменаПараметровСеанса.Найти("CRM_ДоступныеПользователюУровниДоступа") <> Неопределено Тогда
		Если ИспользоватьОграниченияДоступаCRM Тогда
			ПараметрыСеанса.CRM_ДоступныеПользователюУровниДоступа = Новый ФиксированныйМассив(ПолучитьДоступныеУровниДоступа());
		Иначе
			ПараметрыСеанса.CRM_ДоступныеПользователюУровниДоступа = Новый ФиксированныйМассив(Новый Массив);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры // УстановкаПараметровСеанса

// -CRM не переносить в объединенные решения
