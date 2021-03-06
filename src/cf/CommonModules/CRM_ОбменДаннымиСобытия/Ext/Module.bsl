////////////////////////////////////////////////////////////////////////////////
// Обмен CRM_Полный 

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации
// объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации.
//  Источник       - источник события, кроме типа ДокументОбъект.
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиПолныйПередЗаписью(Источник, Отказ) Экспорт
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("CRM_Полный", Источник, Отказ);
	Иначе
		Если CRM_ОбщегоНазначенияСервер.НайтиВМетаданныхПоИмени("ПланыОбмена", "Полный") Тогда
			ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("Полный", Источник, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации.
//  Источник       - ДокументОбъект - источник события.
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиПолныйПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("CRM_Полный", Источник, Отказ, РежимЗаписи, РежимПроведения);
	Иначе
		Если CRM_ОбщегоНазначенияСервер.НайтиВМетаданныхПоИмени("ПланыОбмена", "Полный") Тогда
			ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("Полный", Источник, Отказ, РежимЗаписи, РежимПроведения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" константы для механизма регистрации объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации.
//  Источник       - КонстантаМенеджерЗначения - источник события.
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиПолныйПередЗаписьюКонстанты(Источник, Отказ) Экспорт
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("CRM_Полный", Источник, Отказ);
	Иначе
		Если CRM_ОбщегоНазначенияСервер.НайтиВМетаданныхПоИмени("ПланыОбмена", "Полный") Тогда
			ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("Полный", Источник, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации.
//  Источник       - НаборЗаписейРегистра - источник события.
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
//  Замещение      - Булево - признак замещения существующего набора записей.
// 
Процедура ОбменДаннымиПолныйПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("CRM_Полный", Источник, Отказ, Замещение);
	Иначе
		Если CRM_ОбщегоНазначенияСервер.НайтиВМетаданныхПоИмени("ПланыОбмена", "Полный") Тогда
			ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("Полный", Источник, Отказ, Замещение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации.
//  Источник       - источник события.
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиПолныйПередУдалением(Источник, Отказ) Экспорт
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("CRM_Полный", Источник, Отказ);
	Иначе
		Если CRM_ОбщегоНазначенияСервер.НайтиВМетаданныхПоИмени("ПланыОбмена", "Полный") Тогда
			ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("Полный", Источник, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область ОбменЧерезУниверсальныйФормат

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФормат0ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ, Замещение);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ);
	
КонецПроцедуры

#КонецОбласти