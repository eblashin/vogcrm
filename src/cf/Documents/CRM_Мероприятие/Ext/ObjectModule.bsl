
Перем мНеУстанавливатьПризнакИзмененоВРяде Экспорт; // Признак того, что не нужно устанавливать флаг ИзмененоВРяде.
Перем КонвертацияИнтересов Экспорт; // Запрещать изменение состояния, если документ создаётся конвертированием из события

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполняет список участников мероприятия
//
// Параметры: Нет
//
Процедура ЗаполнитьСписокУчастников() Экспорт
	
	СписокКлиентов = "";
	СписокУчастников = "";
	Для Каждого Участник Из СторонниеЛица Цикл
		Если ЗначениеЗаполнено(Участник.Партнер) Тогда
			СписокКлиентов = СписокКлиентов + ?(СписокКлиентов = "","","; ") + Участник.Партнер;
		КонецЕсли;
		Если ЗначениеЗаполнено(Участник.КонтактноеЛицо) Тогда
			СписокУчастников = СписокУчастников + ?(СписокУчастников = "","","; ") + Участник.КонтактноеЛицо;
		КонецЕсли;
		//+вог
		Если ЗначениеЗаполнено(Участник.вогТорговаяТочка) Тогда
			СписокУчастников = СписокУчастников + ?(СписокУчастников = "","","; ") + Участник.вогТорговаяТочка;
		КонецЕсли;
		//-вог
	КонецЦикла;
	Для Каждого Участник Из СвоиЛица Цикл
		СписокУчастников = СписокУчастников + ?(СписокУчастников = "","","; ") + Участник.Лицо;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПоШаблону(Шаблон) //Павелко, Таск 000000794, 08.11.2019
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шаблон);
	
	ЭтотОбъект.СторонниеЛица.Загрузить(Шаблон.СторонниеЛица.Выгрузить());
	ЭтотОбъект.СвоиЛица.Загрузить(Шаблон.СвоиЛица.Выгрузить());
	ЭтотОбъект.CRM_Теги.Загрузить(Шаблон.CRM_Теги.Выгрузить());
	ЭтотОбъект.Категории.Загрузить(Шаблон.Категории.Выгрузить());
	ЭтотОбъект.вогПрограмма.Загрузить(Шаблон.вогПрограмма.Выгрузить());
	
	мНеУстанавливатьПризнакИзмененоВРяде = Истина;
	
КонецПроцедуры	

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	//Павелко, Таск 000000794, 08.11.2019+++
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.вогШаблоныМероприятий") Тогда
		ЗаполнитьПоШаблону(ДанныеЗаполнения);
		Возврат;
	КонецЕсли;	
	//Павелко, Таск 000000794, 08.11.2019---
	
	CRM_ОбщегоНазначенияСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.CRM_Интерес") Тогда
		ЭтотОбъект.ДокументОснование	= ДанныеЗаполнения.Ссылка;
		ЭтотОбъект.Описание				= ДанныеЗаполнения.Описание;
		ЭтотОбъект.Ответственный		= ДанныеЗаполнения.Ответственный;
		ЭтотОбъект.Подразделение		= ДанныеЗаполнения.Подразделение;
		ЭтотОбъект.Тема					= ДанныеЗаполнения.Тема;
		ЭтотОбъект.Организация			= ДанныеЗаполнения.Организация;
	//ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.CRM_Взаимодействие") Тогда
	//	ЭтотОбъект.ДокументОснование	= ДанныеЗаполнения.ДокументОснование;
	//	ЭтотОбъект.Ответственный		= ДанныеЗаполнения.Ответственный;
	//	ЭтотОбъект.Подразделение		= ДанныеЗаполнения.Подразделение;
	//	ЭтотОбъект.Тема					= ДанныеЗаполнения.Содержание;
	//	ЭтотОбъект.Автор				= ДанныеЗаполнения.Автор;
	//	ЭтотОбъект.Дата					= ДанныеЗаполнения.ПлановаяДата;
	//	ЭтотОбъект.Организация			= ДанныеЗаполнения.Организация;
	
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Партнеры") Тогда
	    Если ДанныеЗаполнения.Ссылка.ЭтоГруппа Тогда
			СтандартнаяОбработка = Ложь;	
			Возврат;
		КонецЕсли;
		ЭтотОбъект.Автор				= Пользователи.АвторизованныйПользователь();
		ЭтотОбъект.Ответственный		= ДанныеЗаполнения.ОсновнойМенеджер;
		ЭтотОбъект.Подразделение		= ДанныеЗаполнения.ОсновнойМенеджер.Подразделение;
		НоваяСтрока = ЭтотОбъект.СторонниеЛица.Добавить();
		НоваяСтрока.Партнер = ДанныеЗаполнения.Ссылка;
		НоваяСтрока.КонтактноеЛицо = ДанныеЗаполнения.CRM_ОсновноеКонтактноеЛицо;
		СтруктураПоиска	= Новый Структура;
		СтруктураПоиска.Вставить("Партнер",			НоваяСтрока.Партнер); 
		СтруктураПоиска.Вставить("КонтактноеЛицо",	НоваяСтрока.КонтактноеЛицо); 
		// Телефон
		Если Константы.CRM_ИспользоватьОповещенияСМС.Получить() Тогда
			СписокТелефонов	= CRM_ОбщегоНазначенияСервер.СформироватьСписокКонтактнойИнформации(СтруктураПоиска, ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон"));
			Если СписокТелефонов.Количество() > 0 Тогда
				ЕстьДляОповещений = Ложь;
				Для Каждого ЭлементСписка Из СписокТелефонов Цикл
					Если ЭлементСписка.Пометка Тогда
						ТелефонныйНомер = ЭлементСписка.Значение;
						Если ТелефонныйНомер.Количество() = 0 Тогда
							НоваяСтрока.Телефон = "";
						Иначе	
							НоваяСтрока.Телефон = ТелефонныйНомер.Представление;
						КонецЕсли;
						ЕстьДляОповещений = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если НЕ ЕстьДляОповещений Тогда
					ТелефонныйНомер = СписокТелефонов[0].Значение;
					Если ТелефонныйНомер.Количество() = 0 Тогда
						НоваяСтрока.Телефон = "";
					Иначе	
						НоваяСтрока.Телефон = ТелефонныйНомер.Представление;
					КонецЕсли;
				КонецЕсли;
			Иначе
				НоваяСтрока.Телефон = "";
			КонецЕсли;
		Иначе
			НоваяСтрока.Телефон = "";
		КонецЕсли;
		// E-майл
		Если Константы.CRM_ИспользоватьОповещенияЭлектроннаяПочта.Получить() Тогда
			СписокАдресов	= CRM_ОбщегоНазначенияСервер.СформироватьСписокКонтактнойИнформации(СтруктураПоиска, ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты"));
			Если СписокАдресов.Количество() > 0 Тогда
				ЕстьДляОповещений = Ложь;
				Для Каждого ЭлементСписка Из СписокАдресов Цикл
					Если ЭлементСписка.Пометка Тогда
						Адрес = ЭлементСписка.Значение;
						Если Адрес.Количество() = 0 Тогда
							НоваяСтрока.Адрес					= "";
							НоваяСтрока.ПредставлениеАдреса	= "";
							НоваяСтрока.Принадлежность		= Ложь;
						Иначе	
							НоваяСтрока.Адрес					= Адрес.Представление;
							НоваяСтрока.ПредставлениеАдреса	= ?(Адрес.Объект = НоваяСтрока.Партнер,Строка(НоваяСтрока.Партнер), Строка(НоваяСтрока.КонтактноеЛицо)) + " <" + Адрес.Представление + ">";
							НоваяСтрока.Принадлежность		= (Адрес.Объект = НоваяСтрока.КонтактноеЛицо);
						КонецЕсли;
						ЕстьДляОповещений = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если НЕ ЕстьДляОповещений Тогда
					Адрес = СписокАдресов[0].Значение;
					Если Адрес.Количество() = 0 Тогда
						НоваяСтрока.Адрес					= "";
						НоваяСтрока.ПредставлениеАдреса	= "";
						НоваяСтрока.Принадлежность		= Ложь;
					Иначе	
						НоваяСтрока.Адрес					= Адрес.Представление;
						НоваяСтрока.ПредставлениеАдреса	= ?(Адрес.Объект = НоваяСтрока.Партнер,Строка(НоваяСтрока.Партнер),Строка(НоваяСтрока.КонтактноеЛицо)) + " <" + Адрес.Представление + ">";
						НоваяСтрока.Принадлежность		= (Адрес.Объект = НоваяСтрока.КонтактноеЛицо);
					КонецЕсли;
				КонецЕсли;
			Иначе
				НоваяСтрока.Адрес					= "";
				НоваяСтрока.ПредставлениеАдреса	= "";
				НоваяСтрока.Принадлежность		= Ложь;
			КонецЕсли;
		Иначе
			НоваяСтрока.Адрес					= "";
			НоваяСтрока.ПредставлениеАдреса	= "";
			НоваяСтрока.Принадлежность		= Ложь;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ЗаполняемИзПланировщика") Тогда
			
			Тема					= ДанныеЗаполнения.Тема;
			Дата					= ДанныеЗаполнения.Дата;
			ОкончаниеМероприятия	= ДанныеЗаполнения.ОкончаниеМероприятия;
			Автор					= Пользователи.ТекущийПользователь();
			Ответственный			= Пользователи.ТекущийПользователь();
			Состояние				= Справочники.CRM_СостоянияСобытий.ВСтадииПодготовки;
			
			ЗначениеНастройки = CRM_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяКатегорияСобытия");
			Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
				ОсновнаяКатегория = ЗначениеНастройки;
			КонецЕсли;
			
			ЗначениеНастройки = CRM_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
			Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
				Если Организация <> ЗначениеНастройки Тогда
					Организация = ЗначениеНастройки;
				КонецЕсли;
			Иначе
				Организация = CRM_ОбщегоНазначенияСервер.ПолучитьПредопределеннуюОрганизацию();
			КонецЕсли;
		Иначе
			Если ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
				CRM_ОбщегоНазначенияСервер.ЗаполнитьИнтересСостояние(ЭтотОбъект, ДанныеЗаполнения.ДокументОснование, Истина);
			КонецЕсли;	
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			//ЭтотОбъект.ДокументОснование	= ДанныеЗаполнения.ДокументОснование;
			//ЭтотОбъект.Ответственный		= ДанныеЗаполнения.Ответственный;
			//ЭтотОбъект.Подразделение		= ДанныеЗаполнения.Подразделение;
			//ЭтотОбъект.Тема					= ДанныеЗаполнения.Тема;
			//ЭтотОбъект.Автор				= ДанныеЗаполнения.Автор;
			//ЭтотОбъект.Дата					= ДанныеЗаполнения.Дата;
		КонецЕсли;
	//+вог
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.CRM_ЭтапКалендарногоПлана") Тогда
		ЗаполнитьПоЭтапуКалендарногоПлана(ДанныеЗаполнения);
	//-вог
	КонецЕсли;
	
	//+вог
	Если СторонниеЛица.Количество() = 0 Тогда
		СторонниеЛица.Добавить();	
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ВидВзаимодействия") Тогда
			вогВидВзаимодействия = ДанныеЗаполнения.ВидВзаимодействия;
		КонецЕсли;	
		
		Если ДанныеЗаполнения.Свойство("Партнер") Тогда
			СторонниеЛица[0].Партнер = ДанныеЗаполнения.Партнер;
		КонецЕсли;	
		
		Если ДанныеЗаполнения.Свойство("ТорговаяТочка") Тогда
			СторонниеЛица[0].вогТорговаяТочка = ДанныеЗаполнения.ТорговаяТочка;
			Если Не ЗначениеЗаполнено(СторонниеЛица[0].Партнер) Тогда
				СторонниеЛица[0].Партнер 		= СторонниеЛица[0].вогТорговаяТочка.Партнер;
				СторонниеЛица[0].КонтактноеЛицо = СторонниеЛица[0].Партнер.CRM_ОсновноеКонтактноеЛицо;
			КонецЕсли;
			
		КонецЕсли;	
	
	КонецЕсли;
	//-вог
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокУчастников();
	
	Если Периодическое И ЗначениеЗаполнено(РядСобытий) И Не ИзмененоВРяде И мНеУстанавливатьПризнакИзмененоВРяде <> Истина Тогда
		ИзмененоВРяде = Истина;
		Периодическое = Ложь;
		//ИначеЕсли ИзмененоВРяде И ЗначениеЗаполнено(РядСобытий) И Не Периодическое Тогда
		//	Периодическое = Истина;
	КонецЕсли;
	
	// +GOOGLE
	Если Не ЗначениеЗаполнено(ЭтотОбъект.ОрганизаторGApi) Тогда
		ЭтотОбъект.ОрганизаторGApi = ЭтотОбъект.Ответственный;
	КонецЕсли;
	// -GOOGLE
	
	// Проверка на Дубли строк в Табличных частях "Свои лица" и "Сторонние лица".
	
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ПериодическоеСобытиеСпособИзмененияРяда") Тогда
		ПериодическоеСобытиеСпособИзмененияРяда = ЭтотОбъект.ДополнительныеСвойства.ПериодическоеСобытиеСпособИзмененияРяда;
	// +GOOGLE
		// при необходимости  удалим старые события и 
		//создадим новый ряд событий
		Если ЗначениеЗаполнено(Ссылка) И ПериодическоеСобытиеСпособИзмененияРяда = "ДоКонцаРяда" Тогда
			ОбработкаСозданияНовогоРяда();
		КонецЕсли;
	КонецЕсли;
	// -GOOGLE
	
	//Если Не ЗначениеЗаполнено(Ссылка) И НЕ КонвертацияИнтересов Тогда
	//	Состояние = Справочники.CRM_СостоянияСобытий.ВСтадииПодготовки;		
	//КонецЕсли; 
	
	// ++ Харченко Д.И. № 000002778 - 19.09.2018 / 
	Если ЗначениеЗаполнено(ПараметрыСеанса.ТекущийПользователь) 
		И НЕ Ответственный = ПараметрыСеанса.ТекущийПользователь
		И ( НЕ НачалоДня(Дата) = НачалоДня(Ссылка.Дата) ИЛИ НЕ Ответственный = Ссылка.Ответственный)
		И НЕ РольДоступна("вогРазрешитьЗадачиНаВыходнойДругому") Тогда
		
		ДанныеДня = CRM_ОбщегоНазначенияПовтИсп.ПолучитьСоответствиеКалендарныхГрафиков(Дата);
		
		Если НЕ ДанныеДня.Получить(НачалоДня(Дата)).ДеньРабочийПоПроизводственномуКалендарю Тогда
			
			ТекстСообщения = "У Вас нет прав назначать задачу другому пользователю на выходной день";
			
			Если ДополнительныеСвойства.Свойство("ЗаписьИзБП") Тогда
				
				Отказ = Истина;
				ДополнительныеСвойства.Вставить("ТекстОшибкиЗаписи", ТекстСообщения); 
				
			Иначе 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;	
	// -- Харченко Д.И. № 000002778 - 19.09.2018
	Если Не Ссылка.Пустая() тогда	
		ДополнительныеСвойства.Вставить("ИсходныйПротокол",Ссылка.вогПротокол.Выгрузить());
	КонецЕсли;
	Если ЗначениеЗаполнено(вогВидВзаимодействия) и ЗначениеЗаполнено(вогВидВзаимодействия.Категория) тогда
		Если Категории.Найти(вогВидВзаимодействия.Категория)=Неопределено тогда
			СтрКат = Категории.Добавить();	
			СтрКат.Категория = вогВидВзаимодействия.Категория; 	
			Если НЕ ЗначениеЗаполнено(ОсновнаяКатегория) тогда
				ОсновнаяКатегория = вогВидВзаимодействия.Категория; 	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ОперационноеПроектное = 1 и Проект.Пустая() тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не указан проект";
		Сообщение.УстановитьДанные(Проект);
		Сообщение.Сообщить();
		Отказ = истина;
	КонецЕсли;
	ПроверитьЗаполнениеСВязанныхРеквизитовПоВидуВзаимодействия(Отказ); //+ VOG Иванов С.А. 02.10.2019 task 564
КонецПроцедуры // ПередЗаписью()

Процедура ПриКопировании(ОбъектКопирования)
	// +GOOGLE
	ОрганизаторGApi = Неопределено;
	// -GOOGLE
	
	// ++ VOG Иванов С.А. 02.10.2019 task 612
	Состояние = Справочники.CRM_СостоянияСобытий.ВСтадииПодготовки;
	Для каждого строкаТЧ Из СвоиЛица Цикл
		строкаТЧ.ОтправлятьПоПочте = Ложь;		
	КонецЦикла;
	вогПротокол.Очистить();
	Периодическое = Ложь;
	РядСобытий = Справочники.CRM_РядыСобытий.ПустаяСсылка();
	// -- VOG Иванов С.А. 02.10.2019 task 612
КонецПроцедуры

#КонецОбласти

#КонецЕсли

Процедура ОбработкаСозданияНовогоРяда()
	// удалим сначала старые 
	ДатаНачала = Дата;
	ДатаОкончания = РядСобытий.ДатаОкончания;
	ДатаНачала		= НачалоДня(ДатаНачала);
	ДатаОкончания	= НачалоДня(ДатаОкончания);
	Если ДатаОкончания <= ДатаНачала Тогда
		РезультатЗапросаПоСобытиямРяда = CRM_МероприятияСервер.ПолучитьРезультатЗапросаПоМероприятиямРяда(РядСобытий,, Мин(ДатаНачала, ДатаОкончания),, Истина, Истина);
	Иначе
		РезультатЗапросаПоСобытиямРяда = CRM_МероприятияСервер.ПолучитьРезультатЗапросаПоМероприятиямРяда(РядСобытий,Ссылка, ДатаНачала, ДатаОкончания, Истина, Истина);
	КонецЕсли;
    ТаблицаСобытий = РезультатЗапросаПоСобытиямРяда.Выгрузить();
	Для Каждого СтрокаСобытия Из  ТаблицаСобытий Цикл
		// Удалим запись из регистра до записи события, при записи события 
		// с пометкой удаления регистр уже очищается.
		НаборЗаписей = РегистрыСведений.CRM_СобытияКалендаря.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(СтрокаСобытия.Мероприятие);
		НаборЗаписей.Прочитать();
		
		// ++ VOG Солодов В.В. 26.08.2021 DEV-717
		ИдентификаторПовтСобытия = Неопределено;
		
		Если НаборЗаписей.Количество() > 0 Тогда
			ИдентификаторПовтСобытия =  НаборЗаписей[0].ИдСобытияGApi;
		КонецЕсли;
		// До изменения
		//ИдентификаторПовтСобытия =  НаборЗаписей[0].ИдСобытияGApi;
		// -- VOG Солодов В.В. 26.08.2021 DEV-717
		
		ОбъектСобытия = СтрокаСобытия.Мероприятие.ПолучитьОбъект();
		ОбъектСобытия.ПометкаУдаления = Истина;
		ОбъектСобытия.Записать();
		АвторСобытия = Неопределено;
		// +GOOGLE
		Если ТипЗнч(ОбъектСобытия.ОрганизаторGApi) = Тип("Строка") Тогда
			ТаблицаОрганизатор =    CRM_GoogleИнтеграция.НайтиКонтакт(ОбъектСобытия.ОрганизаторGApi); 
			Если ТаблицаОрганизатор.Количество()<>0 Тогда
				Если ТипЗнч(ТаблицаОрганизатор[0].Контакт) = Тип("СправочникСсылка.Пользователи") Тогда
					АвторСобытия = ТаблицаОрганизатор[0].Контакт;
				Иначе
					АвторСобытия = ОбъектСобытия.ОрганизаторGApi;	
				КонецЕсли;
			Иначе 
				АвторСобытия = ОбъектСобытия.ОрганизаторGApi;
			КонецЕсли;
		ИначеЕсли ТипЗнч(ОбъектСобытия.ОрганизаторGApi) = Тип("СправочникСсылка.Пользователи") Тогда
			АвторСобытия = ОбъектСобытия.ОрганизаторGApi;	
		КонецЕсли;

		// отправим это событие в Google
		Автор = Неопределено;
		Если ТипЗнч(АвторСобытия) = Тип("Строка") ИЛИ (ТипЗнч(АвторСобытия) = Тип("СправочникСсылка.Пользователи") И ОбъектСобытия.Ответственный <> АвторСобытия) Тогда
			Автор = АвторСобытия;	
		Иначе
			Автор = ОбъектСобытия.Ответственный;
		КонецЕсли;
		
		// ++ VOG Солодов В.В. 26.08.2021 DEV-717
		Если ИдентификаторПовтСобытия = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		// -- VOG Солодов В.В. 26.08.2021 DEV-717
		
		// Удалим из Google
		CRM_GoogleИнтеграция.УдалитьСобытиеИзКалендаря(ОбъектСобытия,Автор, ИдентификаторПовтСобытия);
		// -GOOGLE
	КонецЦикла;

	НовоеРасписание = РядСобытий.Расписание.Получить();
	СтароеРасписание = Неопределено;
	НаборЗаписейРегистра = РегистрыСведений.CRM_СобытияКалендаря.СоздатьНаборЗаписей();
	НаборЗаписейРегистра.Отбор.Объект.Установить(Ссылка);
	НаборЗаписейРегистра.Прочитать();

	Если НЕ НаборЗаписейРегистра.Количество()= 0 Тогда
		СтароеРасписание = НаборЗаписейРегистра[0].Расписание.Получить();
		ИдПовтСобытия =  НаборЗаписейРегистра[0].ИдСобытияGApi;
		АвторСобытия = Неопределено;
		// +GOOGLE
		Если ТипЗнч(Ссылка.ОрганизаторGApi) = Тип("Строка") Тогда
			ТаблицаОрганизатор =    CRM_GoogleИнтеграция.НайтиКонтакт(Ссылка.ОрганизаторGApi); 
			Если ТаблицаОрганизатор.Количество()<>0 Тогда
				Если ТипЗнч(ТаблицаОрганизатор[0].Контакт) = Тип("СправочникСсылка.Пользователи") Тогда
					АвторСобытия = ТаблицаОрганизатор[0].Контакт;
				Иначе
					АвторСобытия = Ссылка.ОрганизаторGApi;	
				КонецЕсли;
			Иначе 
				АвторСобытия = Ссылка.ОрганизаторGApi;
			КонецЕсли;
		ИначеЕсли ТипЗнч(Ссылка.ОрганизаторGApi) = Тип("СправочникСсылка.Пользователи") Тогда
			АвторСобытия = Ссылка.ОрганизаторGApi;	
		КонецЕсли;

		// отправим это событие в Google
		Автор = Неопределено;
		Если ТипЗнч(АвторСобытия) = Тип("Строка") ИЛИ (ТипЗнч(АвторСобытия) = Тип("СправочникСсылка.Пользователи") И Ссылка.Ответственный <> АвторСобытия) Тогда
			Автор = АвторСобытия;	
		Иначе
			Автор = Ссылка.Ответственный;
		КонецЕсли;
		CRM_GoogleИнтеграция.УдалитьСобытиеИзКалендаря(Ссылка.ПолучитьОбъект(),Автор, ИдПовтСобытия);
		// -GOOGLE
	КонецЕсли;
	Если СтароеРасписание <> Неопределено Тогда
						
		НовыйРяд = Справочники.CRM_РядыСобытий.СоздатьЭлемент();
		НовыйРяд.ДатаОкончания  = РядСобытий.ДатаОкончания;
		НовоеРасписание = РядСобытий.Расписание.Получить();  
		НовоеРасписание.ВремяНачала = Дата(1,1,1)+ Час(ЭтотОбъект.Дата)*3600+Минута(ЭтотОбъект.Дата)*60+Секунда(ЭтотОбъект.Дата);
		НовоеРасписание.ВремяКонца  = Дата(1,1,1)+ Час(ЭтотОбъект.ОкончаниеМероприятия)*3600+Минута(ЭтотОбъект.ОкончаниеМероприятия)*60+Секунда(ЭтотОбъект.ОкончаниеМероприятия);
		НовыйРяд.Расписание =  Новый ХранилищеЗначения(НовоеРасписание, Новый СжатиеДанных());
		
		// Вернем обратно значения предыдущего расписания.
		СтарыйРяд = РядСобытий.Получитьобъект();
		СтарыйРяд.ДатаОкончания = Дата;
		СтарыйРяд.Расписание = Новый ХранилищеЗначения(СтароеРасписание, Новый СжатиеДанных);
		СтарыйРяд.Наименование = Строка(СтароеРасписание);
		СтарыйРяд.Записать();
		
		НовыйРяд.ДатаНачала = Дата;  
		НовыйРяд.Наименование  = Строка(НовыйРяд.Расписание.Получить());
		НовыйРяд.Записать();
		ЭтотОбъект.РядСобытий = НовыйРяд.Ссылка;
	КонецЕсли;

КонецПроцедуры

//+вог
Процедура ЗаполнитьПоЭтапуКалендарногоПлана(ДанныеЗаполнения)

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ДополнительныеСвойства.Свойство("ИсходныйПротокол") тогда
		Для каждого ПунктПротокола из ДополнительныеСвойства.ИсходныйПротокол цикл
			Если вогПротокол.Найти(ПунктПротокола.ПунктПротокола) = Неопределено   тогда
				ПунктПротоколаОбъект = ПунктПротокола.ПунктПротокола.ПолучитьОбъект();
				ПунктПротоколаОбъект.Заблокировать();
				ПунктПротоколаОбъект.УстановитьПометкуУдаления(Истина);
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ТребуетсяОбновитьКомандировку") Тогда //Павелко, Задача CRM-284, 11.02.2020
		
		//START Кайдашов 05/02/20 CRM-212	
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	вогКомандировкаЗадачи.Ссылка КАК Ссылка
		               |ИЗ
		               |	Документ.вогКомандировка.Задачи КАК вогКомандировкаЗадачи
		               |ГДЕ
		               |	вогКомандировкаЗадачи.Задача = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() тогда
			ДокКом = Выборка.Ссылка.ПолучитьОбъект();
			Попытка
				ДокКом.Заблокировать();
				ЗаблокировалиДокумент = Истина;	
			Исключение
				ЗаблокировалиДокумент = Ложь;	
			КонецПопытки;
			Если ЗаблокировалиДокумент тогда
				ДокКом.Записать();					
				ДокКом.Разблокировать();
			КонецЕсли;		
		КонецЕсли;
		//END Кайдашов CRM-212
	КонецЕсли;	
		
КонецПроцедуры

//-вог

//++ VOG Иванов С.А. 02.10.2019 task 564
Процедура ПроверитьЗаполнениеСВязанныхРеквизитовПоВидуВзаимодействия(Отказ)
	Если вогВидВзаимодействия = Справочники.CRM_ВидыВзаимодействий.ПолучитьСсылку(Новый УникальныйИдентификатор("b23f6567-97ed-11e9-9b11-005056bcd3e3")) Тогда //встреча с клиентом
		Если НЕ ЗначениеЗаполнено(СторонниеЛица[0].Партнер) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не указан Клиент";
			Сообщение.УстановитьДанные(СторонниеЛица[0].Партнер);
			Сообщение.Сообщить();
			Отказ = истина;		
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СторонниеЛица[0].КонтактноеЛицо) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не указано Контактное лицо";
			Сообщение.УстановитьДанные(СторонниеЛица[0].КонтактноеЛицо);
			Сообщение.Сообщить();
			Отказ = истина;		
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Место) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не указано Место проведения встречи";
			Сообщение.УстановитьДанные(Место);
			Сообщение.Сообщить();
			Отказ = истина;		
		КонецЕсли;
		
	ИначеЕсли вогВидВзаимодействия = Справочники.CRM_ВидыВзаимодействий.ПолучитьСсылку(Новый УникальныйИдентификатор("3ad7458f-97ee-11e9-9b11-005056bcd3e3")) Тогда //встреча с тт
		Если НЕ ЗначениеЗаполнено(СторонниеЛица[0].КонтактноеЛицо) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не указано Контактное лицо";
			Сообщение.УстановитьДанные(СторонниеЛица[0].КонтактноеЛицо);
			Сообщение.Сообщить();
			Отказ = истина;		
		КонецЕсли;	
		Если НЕ ЗначениеЗаполнено(Место) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не указано Место проведения встречи";
			Сообщение.УстановитьДанные(Место);
			Сообщение.Сообщить();
			Отказ = истина;		
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СторонниеЛица[0].вогТорговаяТочка) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не указана Торговая точка";
			Сообщение.УстановитьДанные(СторонниеЛица[0].вогТорговаяТочка);
			Сообщение.Сообщить();
			Отказ = истина;		
		КонецЕсли;
	ИначеЕсли вогВидВзаимодействия = Справочники.CRM_ВидыВзаимодействий.ПолучитьСсылку(Новый УникальныйИдентификатор("9c657cf9-97ed-11e9-9b11-005056bcd3e3")) //цру
		ИЛИ вогВидВзаимодействия = Справочники.CRM_ВидыВзаимодействий.ПолучитьСсылку(Новый УникальныйИдентификатор("32679a50-aa37-11e9-9b11-005056bcd3e3")) //ПИР
		ИЛИ вогВидВзаимодействия = Справочники.CRM_ВидыВзаимодействий.ПолучитьСсылку(Новый УникальныйИдентификатор("32679a51-aa37-11e9-9b11-005056bcd3e3")) Тогда//ВИД
		Если НЕ ЗначениеЗаполнено(Место) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не указано Место проведения встречи";
			Сообщение.УстановитьДанные(Место);
			Сообщение.Сообщить();
			Отказ = истина;		
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры
//-- VOG Иванов С.А. 02.10.2019 task 564

КонвертацияИнтересов = Ложь;



