#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.2.1.4";
	Обработчик.Процедура = "ПолучениеФайловИзИнтернетаСлужебный.ОбновитьХранимыеНастройкиПрокси";
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиента.
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	Параметры.Вставить("НастройкиПроксиСервера", ПолучениеФайловИзИнтернета.НастройкиПроксиНаКлиенте());
	
КонецПроцедуры

// См. РаботаВБезопасномРежимеПереопределяемый.ПриВключенииИспользованияПрофилейБезопасности.
Процедура ПриВключенииИспользованияПрофилейБезопасности() Экспорт
	
	// Сброс настроек прокси-сервера на системные.
	СохранитьНастройкиПроксиНаСервере1СПредприятие(Неопределено);
	
	ЗаписьЖурналаРегистрации(ПолучениеФайловИзИнтернетаКлиентСервер.СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Предупреждение, Метаданные.Константы.НастройкаПроксиСервера,,
		НСтр("ru = 'При включении профилей безопасности настройки прокси-сервера сброшены на системные.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Сохраняет параметры настройки прокси сервера на стороне сервера 1С:Предприятие.
//
Процедура СохранитьНастройкиПроксиНаСервере1СПредприятие(Знач Настройки) Экспорт
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение(НСтр("ru = 'Недостаточно прав для выполнения операции'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.НастройкаПроксиСервера.Установить(Новый ХранилищеЗначения(Настройки));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

// Инициализирует новые настройки прокси-сервера "ИспользоватьПрокси"
// и "ИспользоватьСистемныеНастройки".
//
Процедура ОбновитьХранимыеНастройкиПрокси() Экспорт
	
	МассивПользователейИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для Каждого ПользовательИБ Из МассивПользователейИБ Цикл
		
		НастройкаПроксиСервера = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкаПроксиСервера", "", , , ПользовательИБ.Имя);
		
		Если ТипЗнч(НастройкаПроксиСервера) = Тип("Соответствие") Тогда
			
			СохранитьНастройкиПользователя = Ложь;
			Если НастройкаПроксиСервера.Получить("ИспользоватьПрокси") = Неопределено Тогда
				НастройкаПроксиСервера.Вставить("ИспользоватьПрокси", Ложь);
				СохранитьНастройкиПользователя = Истина;
			КонецЕсли;
			Если НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки") = Неопределено Тогда
				НастройкаПроксиСервера.Вставить("ИспользоватьСистемныеНастройки", Ложь);
				СохранитьНастройкиПользователя = Истина;
			КонецЕсли;
			Если СохранитьНастройкиПользователя Тогда
				ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
					"НастройкаПроксиСервера", "", НастройкаПроксиСервера, , ПользовательИБ.Имя);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	
	Если ТипЗнч(НастройкаПроксиСервера) = Тип("Соответствие") Тогда
		
		СохранитьНастройкиСервера = Ложь;
		Если НастройкаПроксиСервера.Получить("ИспользоватьПрокси") = Неопределено Тогда
			НастройкаПроксиСервера.Вставить("ИспользоватьПрокси", Ложь);
			СохранитьНастройкиСервера = Истина;
		КонецЕсли;
		Если НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки") = Неопределено Тогда
			НастройкаПроксиСервера.Вставить("ИспользоватьСистемныеНастройки", Ложь);
			СохранитьНастройкиСервера = Истина;
		КонецЕсли;
		Если СохранитьНастройкиСервера Тогда
			СохранитьНастройкиПроксиНаСервере1СПредприятие(НастройкаПроксиСервера);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#Если Не ВебКлиент Тогда

Функция ПредставлениеИнтернетПрокси(Прокси)
	
	Журнал = Новый Массив;
	Журнал.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Адрес:  %1:%2
		           |HTTP:   %3:%4
		           |Secure: %5:%6
		           |FTP:    %7:%8'"),
		Прокси.Сервер(),        Формат(Прокси.Порт(),        "ЧГ="),
		Прокси.Сервер("http"),  Формат(Прокси.Порт("http"),  "ЧГ="),
		Прокси.Сервер("https"), Формат(Прокси.Порт("https"), "ЧГ="),
		Прокси.Сервер("ftp"),   Формат(Прокси.Порт("ftp"),   "ЧГ=")));
	
	Если Прокси.ИспользоватьАутентификациюОС("") Тогда 
		Журнал.Добавить(НСтр("ru = 'Используется аутентификация операционной системы'"));
	Иначе 
		Пользователь = Прокси.Пользователь("");
		Пароль = Прокси.Пароль("");
		СостояниеПароля = ?(ПустаяСтрока(Пароль), НСтр("ru = '<не указан>'"), НСтр("ru = '********'"));
		
		Журнал.Добавить(НСтр("ru = 'Используется аутентификация по имени пользователя и паролю'"));
		Журнал.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пользователь: %1
			           |Пароль: %2'"),
			Пользователь,
			СостояниеПароля));
	КонецЕсли;
	
	Если Прокси.НеИспользоватьПроксиДляЛокальныхАдресов Тогда 
		Журнал.Добавить(НСтр("ru = 'Не использовать прокси для локальных адресов'"));
	КонецЕсли;
	
	Если Прокси.НеИспользоватьПроксиДляАдресов.Количество() > 0 Тогда 
		Журнал.Добавить(НСтр("ru = 'Не использовать для следующих адресов:'"));
		Для Каждого ИсключаемыйАдрес Из Прокси.НеИспользоватьПроксиДляАдресов Цикл
			Журнал.Добавить(ИсключаемыйАдрес);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтрСоединить(Журнал, Символы.ПС);
	
КонецФункции

// Возвращает прокси по настройкам НастройкаПроксиСервера для заданного протокола Протокол.
//
// Параметры:
//   НастройкаПроксиСервера - Соответствие:
//		ИспользоватьПрокси - использовать ли прокси-сервер.
//		НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов.
//		ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера.
//		Сервер       - адрес прокси-сервера.
//		Порт         - порт прокси-сервера.
//		Пользователь - имя пользователя для авторизации на прокси-сервере.
//		Пароль       - пароль пользователя.
//		ИспользоватьАутентификациюОС - Булево - признак использования аутентификации средствами операционной системы.
//   Протокол - строка - протокол для которого устанавливаются параметры прокси сервера, например "http", "https",
//                       "ftp".
//
// Возвращаемое значение:
//   ИнтернетПрокси - 
//
Функция НовыйИнтернетПрокси(НастройкаПроксиСервера, Протокол) Экспорт
	
	Если НастройкаПроксиСервера = Неопределено Тогда
		// Системные установки прокси-сервера.
		Возврат Неопределено;
	КонецЕсли;
	
	ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
	Если Не ИспользоватьПрокси Тогда
		// Не использовать прокси-сервер.
		Возврат Новый ИнтернетПрокси(Ложь);
	КонецЕсли;
	
	ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
	Если ИспользоватьСистемныеНастройки Тогда
		// Системные настройки прокси-сервера.
		Возврат Новый ИнтернетПрокси(Истина);
	КонецЕсли;
	
	// Настройки прокси-сервера, заданные вручную.
	Прокси = Новый ИнтернетПрокси;
	
	// Определение адреса и порта прокси-сервера.
	ДополнительныеНастройки = НастройкаПроксиСервера.Получить("ДополнительныеНастройкиПрокси");
	ПроксиПоПротоколу = Неопределено;
	Если ТипЗнч(ДополнительныеНастройки) = Тип("Соответствие") Тогда
		ПроксиПоПротоколу = ДополнительныеНастройки.Получить(Протокол);
	КонецЕсли;
	
	ИспользоватьАутентификациюОС = НастройкаПроксиСервера.Получить("ИспользоватьАутентификациюОС");
	ИспользоватьАутентификациюОС = ?(ИспользоватьАутентификациюОС = Истина, Истина, Ложь);
	
	Если ТипЗнч(ПроксиПоПротоколу) = Тип("Структура") Тогда
		Прокси.Установить(Протокол, ПроксиПоПротоколу.Адрес, ПроксиПоПротоколу.Порт,
			НастройкаПроксиСервера["Пользователь"], НастройкаПроксиСервера["Пароль"], ИспользоватьАутентификациюОС);
	Иначе
		Прокси.Установить(Протокол, НастройкаПроксиСервера["Сервер"], НастройкаПроксиСервера["Порт"], 
			НастройкаПроксиСервера["Пользователь"], НастройкаПроксиСервера["Пароль"], ИспользоватьАутентификациюОС);
	КонецЕсли;
	
	Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкаПроксиСервера["НеИспользоватьПроксиДляЛокальныхАдресов"];
	
	АдресаИсключений = НастройкаПроксиСервера.Получить("НеИспользоватьПроксиДляАдресов");
	Если ТипЗнч(АдресаИсключений) = Тип("Массив") Тогда
		Для каждого АдресИсключения Из АдресаИсключений Цикл
			Прокси.НеИспользоватьПроксиДляАдресов.Добавить(АдресИсключения);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

#КонецЕсли

#Область ДиагностикаСоединения

// Служебная информация для отображения текущих настроек и состояний прокси для выполнения диагностики.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//     * СоединениеЧерезПрокси - Булево - Признак того, что соединение должно выполняться через прокси.
//     * Представление - Строка - Представление текущего настроенного прокси.
//
Функция СостояниеНастроекПрокси() Экспорт
	
	Прокси = ПолучениеФайловИзИнтернета.ПолучитьПрокси("http");
	НастройкиПрокси = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	
	Журнал = Новый Массив;
	
	Если НастройкиПрокси = Неопределено Тогда 
		Журнал.Добавить(НСтр("ru = 'Параметры прокси-сервера в ИБ не указаны (используются системные настройки прокси).'"));
	ИначеЕсли Не НастройкиПрокси.Получить("ИспользоватьПрокси") Тогда
		Журнал.Добавить(НСтр("ru = 'Параметры прокси-сервера в ИБ: Не использовать прокси-сервер.'"));
	ИначеЕсли НастройкиПрокси.Получить("ИспользоватьСистемныеНастройки") Тогда
		Журнал.Добавить(НСтр("ru = 'Параметры прокси-сервера в ИБ: Использовать системные настройки прокси-сервера.'"));
	Иначе
		Журнал.Добавить(НСтр("ru = 'Параметры прокси-сервера в ИБ: Использовать другие настройки прокси-сервера.'"));
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда 
		Прокси = Новый ИнтернетПрокси(Истина);
	КонецЕсли;
	
	УказанПроксиВсехАдресов = Не ПустаяСтрока(Прокси.Сервер());
	УказанПроксиHTTP = Не ПустаяСтрока(Прокси.Сервер("http"));
	УказанПроксиHTTPS = Не ПустаяСтрока(Прокси.Сервер("https"));
	
	СоединениеЧерезПрокси = УказанПроксиВсехАдресов Или УказанПроксиHTTP Или УказанПроксиHTTPS;
	
	Если СоединениеЧерезПрокси Тогда 
		Журнал.Добавить(НСтр("ru = 'Соединение выполняется через прокси-сервер:'"));
		Журнал.Добавить(ПредставлениеИнтернетПрокси(Прокси));
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("СоединениеЧерезПрокси", СоединениеЧерезПрокси);
	Результат.Вставить("Представление", СтрСоединить(Журнал, Символы.ПС));
	Результат.Вставить("ИспользуютсяСистемныеНастройкиПрокси", НастройкиПрокси = Неопределено Или НастройкиПрокси["ИспользоватьСистемныеНастройки"] = Истина);
	
	Возврат Результат;
	
КонецФункции

Функция ПредставлениеМестаДиагностики() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат НСтр("ru = 'Подключение проводится на сервере 1С:Предприятия в интернете (модель сервиса).'");
	Иначе 
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			Если ОбщегоНазначения.КлиентПодключенЧерезВебСервер() Тогда 
				Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Подключение проводится из файловой информационной базы на веб-сервере <%1>.'"), ИмяКомпьютера());
			Иначе 
				Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Подключение проводится из файловой информационной базы на компьютере <%1>.'"), ИмяКомпьютера());
			КонецЕсли;
		Иначе
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Подключение проводится на сервере 1С:Предприятие <%1>.'"), ИмяКомпьютера());
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция ПроверитьДоступностьСервера(АдресСервера) Экспорт
	
	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
	ПараметрыЗапускаПрограммы.ПолучитьПотокВывода = Истина;
	ПараметрыЗапускаПрограммы.ПолучитьПотокОшибок = Истина;
	ПараметрыЗапускаПрограммы.КодировкаИсполнения = "OEM";
	
	Если ОбщегоНазначения.ЭтоWindowsСервер() Тогда
		ШаблонКоманды = "ping %1 -n 2 -w 500";
	Иначе
		ШаблонКоманды = "ping -c 2 -w 500 %1";
	КонецЕсли;
	
	СтрокаКоманды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонКоманды, АдресСервера);
	
	Результат = ФайловаяСистема.ЗапуститьПрограмму(СтрокаКоманды, ПараметрыЗапускаПрограммы);
	
	// Разные операционные системы могут выводить ошибки в разные потоки:
	// - для Windows все всегда в потоке вывода;
	// - для Debian или RHEL ошибки падают в поток ошибок.
	ЖурналДоступности = Результат.ПотокВывода + Результат.ПотокОшибок;
	
	Если ОбщегоНазначения.ЭтоWindowsСервер() Тогда
		ФактНедоступности = (СтрНайти(ЖурналДоступности, "Destination host unreachable") > 0); // Не локализуется.
		БезПотерь = (СтрНайти(ЖурналДоступности, "(0% loss)") > 0); // Не локализуется.
	Иначе 
		ФактНедоступности = (СтрНайти(ЖурналДоступности, "Destination Host Unreachable") > 0); // Не локализуется.
		БезПотерь = (СтрНайти(ЖурналДоступности, "0% packet loss") > 0) // не локализуется.
	КонецЕсли;
	
	Доступен = Не ФактНедоступности И БезПотерь;
	
	Журнал = Новый Массив;
	Если Доступен Тогда
		Журнал.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Удаленный сервер %1 доступен:'"), 
			АдресСервера));
	Иначе
		Журнал.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Удаленный сервер %1 не доступен:'"), 
			АдресСервера));
	КонецЕсли;
	
	Журнал.Добавить("> " + СтрокаКоманды);
	Журнал.Добавить(ЖурналДоступности);
	
	Возврат Новый Структура("Доступен, ЖурналДиагностики", Доступен, СтрСоединить(Журнал, Символы.ПС));
	
КонецФункции

Функция ЖурналТрассировкиМаршрутаСервера(АдресСервера) Экспорт
	
	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
	ПараметрыЗапускаПрограммы.ПолучитьПотокВывода = Истина;
	ПараметрыЗапускаПрограммы.ПолучитьПотокОшибок = Истина;
	ПараметрыЗапускаПрограммы.КодировкаИсполнения = "OEM";
	
	Если ОбщегоНазначения.ЭтоWindowsСервер() Тогда
		ШаблонКоманды = "tracert -w 100 -h 15 %1";
	Иначе 
		// Если вдруг пакет traceroute не установлен - в потоке вывода будет ошибка.
		// Т.к. результат все равно не разбирается, на поток вывода можно не обращать внимания.
		// По нему администратор поймет что ему надо доставить.
		ШаблонКоманды = "traceroute -w 100 -m 100 %1";
	КонецЕсли;
	
	СтрокаКоманды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонКоманды, АдресСервера);
	
	Результат = ФайловаяСистема.ЗапуститьПрограмму(СтрокаКоманды, ПараметрыЗапускаПрограммы);
	
	Журнал = Новый Массив;
	Журнал.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Трассировка маршрута к удаленному серверу %1:'"), АдресСервера));
	
	Журнал.Добавить("> " + СтрокаКоманды);
	Журнал.Добавить(Результат.ПотокВывода);
	Журнал.Добавить(Результат.ПотокОшибок);
	
	Возврат СтрСоединить(Журнал, Символы.ПС);
	
КонецФункции

#КонецОбласти

#КонецОбласти
