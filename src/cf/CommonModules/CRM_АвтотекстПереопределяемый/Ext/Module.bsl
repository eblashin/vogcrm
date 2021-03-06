
// Процедура формирует список автотекста.
//
// Параметры:
//	ТаблицаАвтотекста	- ТаблицаЗначений	- Таблица автотекста.
//
Процедура СформироватьСписокАвтотекста(ТаблицаАвтотекста, НазначенияАвтотекста = Неопределено, АвтотекстТемы = Ложь, ТолькоТегиПисьма = Ложь, НачальныйНомер = 0) Экспорт
	Если НазначенияАвтотекста = Неопределено Тогда
		НовыйТэг = ТаблицаАвтотекста.Добавить();
		НовыйТэг.Тэг					= "%ВРЕМЯ%";
		НовыйТэг.ИмяКоманды				= ?(АвтотекстТемы,"Тема","")+"ВставитьВремя";
		НовыйТэг.ЗаголовокКоманды		= "%ВРЕМЯ%";
		НовыйТэг = ТаблицаАвтотекста.Добавить();
		НовыйТэг.Тэг					= "%ДАТА%";
		НовыйТэг.ИмяКоманды				= ?(АвтотекстТемы,"Тема","")+"ВставитьДату";
		НовыйТэг.ЗаголовокКоманды		= "%ДАТА%";
		НовыйТэг = ТаблицаАвтотекста.Добавить();
		НовыйТэг.Тэг					= "%ДАТА_ВРЕМЯ%";
		НовыйТэг.ИмяКоманды				= ?(АвтотекстТемы,"Тема","")+"ВставитьДату_Время";
		НовыйТэг.ЗаголовокКоманды		= "%ДАТА_ВРЕМЯ%";
		НовыйТэг = ТаблицаАвтотекста.Добавить();
		НовыйТэг.Тэг					= "%УВАЖАЕМЫЙ/УВАЖАЕМАЯ%";
		НовыйТэг.ИмяКоманды				= ?(АвтотекстТемы,"Тема","")+"УважаемыйУважаемая";
		НовыйТэг.ЗаголовокКоманды		= "%УВАЖАЕМЫЙ/УВАЖАЕМАЯ%";
		НовыйТэг = ТаблицаАвтотекста.Добавить();
		НовыйТэг.Тэг					= "%ПОЛУЧАТЕЛЬ%";
		НовыйТэг.ИмяКоманды				= ?(АвтотекстТемы,"Тема","")+"ВставитьПолучатель";
		НовыйТэг.ЗаголовокКоманды		= "%ПОЛУЧАТЕЛЬ%";
		НовыйТэг = ТаблицаАвтотекста.Добавить();
		НовыйТэг.Тэг					= "%ПОЛУЧАТЕЛЬ_ИМЯ%";
		НовыйТэг.ИмяКоманды				= ?(АвтотекстТемы,"Тема","")+"ВставитьПолучатель_Имя";
		НовыйТэг.ЗаголовокКоманды		= "%ПОЛУЧАТЕЛЬ_ИМЯ%";
		НовыйТэг = ТаблицаАвтотекста.Добавить();
		НовыйТэг.Тэг					= "%ПОЛУЧАТЕЛЬ_ИМЯ_ОТЧЕСТВО%";
		НовыйТэг.ИмяКоманды				= ?(АвтотекстТемы,"Тема","")+"ВставитьПолучатель_Имя_Отчество";
		НовыйТэг.ЗаголовокКоманды		= "%ПОЛУЧАТЕЛЬ_ИМЯ_ОТЧЕСТВО%";
		НовыйТэг = ТаблицаАвтотекста.Добавить();
		НовыйТэг.Тэг					= "%ПОЛУЧАТЕЛЬ_ФАМИЛИЯ_И_О%";
		НовыйТэг.ИмяКоманды				= ?(АвтотекстТемы,"Тема","")+"ВставитьПолучатель_Фамилия_И_О";
		НовыйТэг.ЗаголовокКоманды		= "%ПОЛУЧАТЕЛЬ_ФАМИЛИЯ_И_О%";
		НовыйТэг = ТаблицаАвтотекста.Добавить();
		НовыйТэг.Тэг					= "%УВАЖАЕМОМУ_ПОЛУЧАТЕЛЮ_ФАМИЛИЯ_ИМЯ_ОТЧЕСТВО%";
		НовыйТэг.ИмяКоманды				= ?(АвтотекстТемы,"Тема","")+"ВставитьПолучатель_Фамилия_И_О_1";
		НовыйТэг.ЗаголовокКоманды		= "%УВАЖАЕМОМУ_ПОЛУЧАТЕЛЮ_ФАМИЛИЯ_ИМЯ_ОТЧЕСТВО%";
	Иначе
		
		ДобавлятьТэгLAT = (ТаблицаАвтотекста.Колонки.Найти("ТэгLAT")<>Неопределено);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Назначение",НазначенияАвтотекста);
		Запрос.Текст = "ВЫБРАТЬ
		|	CRM_ШаблоныАвтотекста.Назначение,
		|	CRM_ШаблоныАвтотекста.Действие,
		|	CRM_ШаблоныАвтотекста.Представление,
		|	CRM_ШаблоныАвтотекста.ПредставлениеLAT,
		|	CRM_ШаблоныАвтотекста.Родитель
		|ИЗ
		|	Справочник.CRM_ШаблоныАвтотекста КАК CRM_ШаблоныАвтотекста
		|ГДЕ
		|	CRM_ШаблоныАвтотекста.Назначение = &Назначение
		|	И НЕ CRM_ШаблоныАвтотекста.ПометкаУдаления
		|	И НЕ CRM_ШаблоныАвтотекста.ЭтоГруппа";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Ном = НачальныйНомер;
		Пока Выборка.Следующий() Цикл
			Если ТолькоТегиПисьма 
				И (Выборка.Родитель = Справочники.CRM_ШаблоныАвтотекста.Анкетирование) Тогда
					Продолжить;
			КонецЕсли;				
			Ном = Ном + 1;
			НовыйТэг = ТаблицаАвтотекста.Добавить();
			НовыйТэг.Тэг					= "%"+Выборка.Представление+"%";
			НовыйТэг.ИмяКоманды				= ?(АвтотекстТемы,"Тема","")+"ВставитьТэг_"+Строка(Ном);
			НовыйТэг.ЗаголовокКоманды		= "%"+Выборка.Представление+"%";
			НовыйТэг.Действие				= Выборка.Действие;
			Если ДобавлятьТэгLAT Тогда
				НовыйТэг.ТэгLAT					= "{{"+Выборка.ПредставлениеLAT+"}}";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // СформироватьСписокАвтотекста()

// Процедура заполняет командную панель форматированного документа.
//
// Параметры:
//	Форма	- Управляемая форма	- Форма, на которой заполняется командная панель.
//  ДобавлятьВКонтекстноеМеню - Булево, признак что нужно добавить пункты в контекстное меню.
//
Процедура ЗаполнитьКоманднуюПанельФорматированногоДокумента(Форма, ДобавлятьВКонтекстноеМеню = Ложь, КоличествоДополнительныхКомандныхПанелей = 0, АвтотекстТемы = Ложь) Экспорт
	Для Каждого СтрокаАвтотекста Из Форма.ТаблицаАвтотекста Цикл
		
		Если Лев(СтрокаАвтотекста.ИмяКоманды,4) = "Тема" Тогда
			Если НЕ АвтотекстТемы Тогда
				Продолжить;
			КонецЕсли;
		Иначе
			Если АвтотекстТемы Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		НоваяКомандаФормы = Форма.Команды.Добавить(СтрокаАвтотекста.ИмяКоманды);
		НоваяКомандаФормы.Заголовок					= СтрокаАвтотекста.ЗаголовокКоманды;
		НоваяКомандаФормы.Действие					= "Подключаемый_ВставитьТэг";
		НоваяКомандаФормы.ИзменяетСохраняемыеДанные	= Истина;
		
		НовыйПунктМеню = Форма.Элементы.Вставить(СтрокаАвтотекста.ИмяКоманды, Тип("КнопкаФормы"), ?(АвтотекстТемы,Форма.Элементы.АвтоТекстТемы,Форма.Элементы.АвтоТекст));
		НовыйПунктМеню.ИмяКоманды			= СтрокаАвтотекста.ИмяКоманды;
		НовыйПунктМеню.Отображение			= ОтображениеКнопки.Текст;
		
		Если ДобавлятьВКонтекстноеМеню Тогда
			КонтекстноеМенюКонтекст = Форма.Элементы.Вставить(СтрокаАвтотекста.ИмяКоманды+"Контекст", Тип("КнопкаФормы"), Форма.Элементы.АвтоТекстКонтекст);	
			КонтекстноеМенюКонтекст.ИмяКоманды	= СтрокаАвтотекста.ИмяКоманды;
			КонтекстноеМенюКонтекст.Отображение	= ОтображениеКнопки.Текст;
		КонецЕсли;
		
		Для Ном = 1 По КоличествоДополнительныхКомандныхПанелей Цикл
			НовыйПунктМеню = Форма.Элементы.Вставить(СтрокаАвтотекста.ИмяКоманды+"_"+Строка(Ном), Тип("КнопкаФормы"), Форма.Элементы["АвтоТекст_"+Строка(Ном)]);
			НовыйПунктМеню.ИмяКоманды			= СтрокаАвтотекста.ИмяКоманды;
			НовыйПунктМеню.Отображение			= ОтображениеКнопки.Текст;
			
			Если ДобавлятьВКонтекстноеМеню Тогда
				КонтекстноеМенюКонтекст = Форма.Элементы.Вставить(СтрокаАвтотекста.ИмяКоманды+"Контекст_"+Строка(Ном), Тип("КнопкаФормы"), Форма.Элементы["АвтоТекстКонтекст_"+Строка(Ном)]);
				КонтекстноеМенюКонтекст.ИмяКоманды	= СтрокаАвтотекста.ИмяКоманды;
				КонтекстноеМенюКонтекст.Отображение	= ОтображениеКнопки.Текст;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
КонецПроцедуры // ЗаполнитьКоманднуюПанельФорматированногоДокумента()

// Процедура заполняет командную панель сообщениями СМС.
//
// Параметры:
//	Форма	- Управляемая форма	- Форма, на которой заполняется командная панель.
//
Процедура ЗаполнитьКоманднуюПанельСообщенияСМС(Форма) Экспорт
	Для Каждого СтрокаАвтотекста Из Форма.ТаблицаАвтотекста Цикл
		ИмяКоманды = СтрокаАвтотекста.ИмяКоманды+"_СМС";
		НоваяКомандаФормы = Форма.Команды.Добавить(ИмяКоманды);
		НоваяКомандаФормы.Заголовок					= СтрокаАвтотекста.ЗаголовокКоманды;
		НоваяКомандаФормы.Действие					= "Подключаемый_ВставитьТэгСМС";
		НоваяКомандаФормы.ИзменяетСохраняемыеДанные	= Истина;
		НовыйПунктМеню = Форма.Элементы.Вставить(ИмяКоманды, Тип("КнопкаФормы"), Форма.Элементы.АвтоТекстСМС);
		НовыйПунктМеню.ИмяКоманды			= ИмяКоманды;
		НовыйПунктМеню.Отображение			= ОтображениеКнопки.Текст;
	КонецЦикла;
КонецПроцедуры // ЗаполнитьКоманднуюПанельСообщенияСМС()

// Функция получает значение тэга.
//
// Параметры:
//	Тэг				- Строка				- Тэг, значение которого необходимо получить.
//	СтрокаТаблицы	- СтрокаТаблицыЗначений	- Строка таблицы значений.
//
// Возвращаемое значение:
//	Строка	- Значение тэга
//
Функция ПолучитьЗначениеТэга(СтрокаАвтотекста, СтрокаТаблицы) Экспорт
	
	Тэг = СтрокаАвтотекста.Тэг;
	
	Возврат ПолучитьРезультатДействия(СтрокаАвтотекста.Действие, Тэг, СтрокаТаблицы);
	
КонецФункции // ПолучитьЗначениеТэга()

// Функция получает значение тэга СМС.
//
// Параметры:
//	Тэг			- Строка			- Тэг, значение которого необходимо получить.
//	Получатель	- СправочникСсылка	- Получатель СМС
//
// Возвращаемое значение:
//	Строка	- Значение тэга
//
Функция ПолучитьЗначениеТэгаСМС(СтрокаАвтотекста, Объект) Экспорт
	
	Тэг = СтрокаАвтотекста.Тэг;
	Возврат ПолучитьРезультатДействия(СтрокаАвтотекста.Действие, Тэг, Объект);

КонецФункции // ПолучитьЗначениеТэгаСМС()

// Функция проверяет выполнение действия.
//
// Параметры:
//	Действие
//	СсылкаНаОбъект
//  Назначение
//	ИмяТабличнойЧасти
//	ТабличнаяЧастьПредставление
//
// Возвращаемое значение:
//	Булево
//
Функция ПроверитьВыполнениеДействия(Действие, СсылкаНаОбъект, Назначение, ИмяТабличнойЧасти, ТабличнаяЧастьПредставление) Экспорт
	
	Результат = "";
	
	Если Назначение = Перечисления.CRM_НазначенияАвтотекста.ТегШаблонаЗначениеКолонки Тогда
		
		Если ИмяТабличнойЧасти = "" Тогда
			ТекстСообщения = НСтр("ru = 'Не указана табличная часть.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		
		Если СсылкаНаОбъект[ИмяТабличнойЧасти].Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'В выбранном объекте для проверки в табличной части %ТабличнаяЧасть% отсутствуют данные.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТабличнаяЧасть%", ТабличнаяЧастьПредставление);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		
		Если ТипЗнч(СсылкаНаОбъект) = Тип("ДокументСсылка.КоммерческоеПредложениеКлиенту") И ИмяТабличнойЧасти = "Товары" Тогда
			Возврат Истина;
		Иначе
			Для Каждого Объект Из СсылкаНаОбъект[ИмяТабличнойЧасти] Цикл
				Попытка
					Выполнить(Действие);
				Исключение
					ТекстСообщения = НСтр("ru = 'Ошибка выполнения действия:'") + Символы.ПС + ОписаниеОшибки();
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
					Возврат Ложь;
				КонецПопытки;
			КонецЦикла;
			
			ТекстСообщения = НСтр("ru = 'Действие выполнено успешно.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Истина;
		КонецЕсли;
		
	ИначеЕсли Назначение = Перечисления.CRM_НазначенияАвтотекста.ТегШаблона Тогда
		
		Объект = СсылкаНаОбъект;
		Попытка
			Выполнить(Действие);
			ТекстСообщения = НСтр("ru = 'Действие выполнено успешно.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Исключение
			ТекстСообщения = НСтр("ru = 'Ошибка выполнения действия:'") + Символы.ПС + ОписаниеОшибки();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
		
	ИначеЕсли Назначение = Перечисления.CRM_НазначенияАвтотекста.АвтотекстЭлектронноеПисьмо Тогда
		
		Объект = Новый Структура;
		Объект.Вставить("Партнер", Справочники.Партнеры.ПустаяСсылка());
		Объект.Вставить("КонтактноеЛицо", Справочники.КонтактныеЛицаПартнеров.ПустаяСсылка());
		
		Если СсылкаНаОбъект.ПолучателиПисьма.Количество() > 0 Тогда
			
			Клиент = СсылкаНаОбъект.ПолучателиПисьма[0].Контакт;
			
			Если ЗначениеЗаполнено(Клиент) Тогда
				Если ТипЗнч(Клиент) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
					Объект.КонтактноеЛицо = Клиент;
				ИначеЕсли ТипЗнч(Клиент) = Тип("СправочникСсылка.Партнеры") Тогда
					Объект.Партнер = Клиент;
				ИначеЕсли ТипЗнч(Клиент) = Тип("СправочникСсылка.Пользователи") Тогда
					Объект.Партнер = Новый Структура("Наименование", СокрЛП(Клиент.Наименование));
				ИначеЕсли ТипЗнч(Клиент) = Тип("Строка") Тогда
					Если ЗначениеЗаполнено(СокрЛП(СсылкаНаОбъект.ПолучателиПисьма[0].Представление)) Тогда
						Объект.Партнер = Новый Структура("Наименование", СокрЛП(Объект.ПолучателиПисьма[0].Представление));
					Иначе
						Объект.Партнер = Новый Структура("Наименование", СокрЛП(Клиент));
					КонецЕсли;
				Иначе
					Попытка
						Объект.Партнер = Новый Структура("Наименование", СокрЛП(Клиент.Наименование));
					Исключение
					КонецПопытки;
				КонецЕсли;
			Иначе
				Если ЗначениеЗаполнено(СокрЛП(СсылкаНаОбъект.ПолучателиПисьма[0].Представление)) Тогда
					Объект.Партнер = Новый Структура("Наименование", СокрЛП(СсылкаНаОбъект.ПолучателиПисьма[0].Представление));
				Иначе
					Объект.Партнер = Новый Структура("Наименование", СокрЛП(СсылкаНаОбъект.ПолучателиПисьма[0].Адрес));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Попытка
			Выполнить(Действие);
			ТекстСообщения = НСтр("ru = 'Действие выполнено успешно.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Исключение
			ТекстСообщения = НСтр("ru = 'Ошибка выполнения действия:'") + Символы.ПС + ОписаниеОшибки();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
		
	ИначеЕсли Назначение = Перечисления.CRM_НазначенияАвтотекста.АвтотекстСМССообщение
	ИЛИ Назначение = Перечисления.CRM_НазначенияАвтотекста.АвтотекстЗадачаИсполнителя Тогда
		
		Объект = СсылкаНаОбъект;
		Попытка
			Выполнить(Действие);
			ТекстСообщения = НСтр("ru = 'Действие выполнено успешно.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Исключение
			ТекстСообщения = НСтр("ru = 'Ошибка выполнения действия:'") + Символы.ПС + ОписаниеОшибки();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьРезультатДействия(Действие, Тэг, Объект = Неопределено, ДополнительныеПараметры = Неопределено)
	
	Результат = "";
	Попытка
		Выполнить(Действие);
	Исключение
		Если СтрНайти(Действие, "Объект.Пользователь") > 0 Тогда
			Результат = Нстр("ru = '&lt;Тег &lt;'") + Тэг + Нстр("ru = '&gt; не доступен для данного объекта&gt;'");
			Возврат Результат;
		Иначе			
			ТекстСообщения = НСтр("ru = 'Ошибка выполнения действия тега:'") + Тэг + Символы.ПС + ОписаниеОшибки();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция получает структуру тэгов шаблона.
//
// Параметры:
//	СсылкаНаОбъект
//	ИмяТабличнойЧасти
//	ДополнительныеПараметры
//
// Возвращаемое значение:
//	Структура
//
Функция ПолучитьСтруктуруТеговШаблона(СсылкаНаОбъект, ИмяТабличнойЧасти = "", ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ИмяТабличнойЧасти = "" Тогда
		Принадлежность = Метаданные.НайтиПоТипу(ТипЗнч(СсылкаНаОбъект)).ПолноеИмя();
		Назначение = Перечисления.CRM_НазначенияАвтотекста.ТегШаблона;
	Иначе
		Принадлежность = Метаданные.НайтиПоТипу(ТипЗнч(ДополнительныеПараметры.Ссылка)).ПолноеИмя();
		Назначение = Перечисления.CRM_НазначенияАвтотекста.ТегШаблонаЗначениеКолонки;
	КонецЕсли;
	
	СтруктураТегов = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Принадлежность"		,Принадлежность);
	Запрос.УстановитьПараметр("Назначение"			,Назначение);
	Запрос.УстановитьПараметр("ИмяТабличнойЧасти"	,ИмяТабличнойЧасти);
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	CRM_ШаблоныАвтотекста.Представление,
	|	CRM_ШаблоныАвтотекста.Действие
	|ИЗ
	|	Справочник.CRM_ШаблоныАвтотекста КАК CRM_ШаблоныАвтотекста
	|ГДЕ
	|	НЕ CRM_ШаблоныАвтотекста.ЭтоГруппа
	|	И НЕ CRM_ШаблоныАвтотекста.ПометкаУдаления
	|	И CRM_ШаблоныАвтотекста.Принадлежность = &Принадлежность
	|	И CRM_ШаблоныАвтотекста.Назначение = &Назначение";
	Если НЕ ИмяТабличнойЧасти = "" Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И CRM_ШаблоныАвтотекста.ИмяТабличнойЧасти = &ИмяТабличнойЧасти";
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Тег				= Выборка.Представление;
		ЗначениеТега	= ПолучитьРезультатДействия(Выборка.Действие, Тег, СсылкаНаОбъект, ДополнительныеПараметры);
		
		СтруктураТегов.Вставить(Тег, ЗначениеТега);
		
	КонецЦикла;
	
	Возврат СтруктураТегов;
	
КонецФункции
