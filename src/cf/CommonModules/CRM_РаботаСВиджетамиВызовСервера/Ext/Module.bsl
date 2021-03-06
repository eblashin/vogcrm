
////////////////////////////////////////////////////////////////////////////////
// Серверные процедуры и функции для работы с виджетами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет виджеты формы Текущие дела.
//
// Параметры:
//   Форма - УправляемаяФорма с виджетами.
//   Виджеты - Массив - массив ссылок на виджеты, которые следует заполнить.
//
Процедура ЗаполнитьВиджетыТекущихДел(Форма, ГруппаВиджеты = "", ПервыйЗапуск = Ложь) Экспорт
	
	НомерВиджета = 1;
	
	// удалим все виджеты с формы
	МассивУдаляемых = Новый Массив;
	Если НЕ ПервыйЗапуск Тогда
		Для Сч = 1 По Форма.КоличествоВиджетовНаФорме Цикл
			ИндексВиджета = Формат(Сч, "ЧЦ=2; ЧДЦ=; ЧВН=");
			МассивУдаляемых.Добавить("Виджет" + ИндексВиджета);
			
			УдаляемыйЭлемент = Форма.Элементы.Найти("ГруппаВиджет" + ИндексВиджета);
			Если УдаляемыйЭлемент <> Неопределено Тогда
				Форма.Элементы.Удалить(УдаляемыйЭлемент);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Добавим виджеты по новым данным.
	МассивДобавляемых = Новый Массив;
	МассивНовыхЭлементов = Новый Массив;
	Для Каждого ЭлементВиджет Из Форма.СписокВиджетовПользователя Цикл
		ИндексВиджета = ЭлементВиджет.Представление;
		СтрокаHTML = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
		
		МассивДобавляемых.Добавить(Новый РеквизитФормы("Виджет" + ИндексВиджета, СтрокаHTML));
	КонецЦикла;
	
	Форма.ИзменитьРеквизиты(МассивДобавляемых, МассивУдаляемых);
	
	// создадим элементы формы
	Индекс = 0;
	Для Каждого Реквизит Из МассивДобавляемых Цикл
		
		ЭлементСписка = Форма.СписокВиджетовПользователя.Получить(Индекс);
		Форма[Реквизит.Имя] = ЗаполнитьHTMLПолеВиджета(ЭлементСписка.Значение, ЭлементСписка.Представление);
		Индекс = Индекс + 1;
		
		НоваяГруппаФормы = Форма.Элементы.Вставить("Группа" + Реквизит.Имя, Тип("ГруппаФормы"), ?(ГруппаВиджеты <> "", Форма.Элементы[ГруппаВиджеты], Неопределено), Форма.Элементы.ДекорацияДобавитьНовыйВиджет);
		НоваяГруппаФормы.Вид = ВидГруппыФормы.ОбычнаяГруппа; 
		НоваяГруппаФормы.Отображение = ОтображениеОбычнойГруппы.Нет;
		НоваяГруппаФормы.ОтображатьЗаголовок = Ложь;
		НоваяГруппаФормы.Высота = 6;
		НоваяГруппаФормы.Ширина = 23; 
		НоваяГруппаФормы.РастягиватьПоВертикали = Ложь; 
		НоваяГруппаФормы.РастягиватьПоГоризонтали = Ложь; 
		
		НовыйЭлемент = Форма.Элементы.Добавить(Реквизит.Имя, Тип("ПолеФормы"), НоваяГруппаФормы);
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		НовыйЭлемент.Высота = 6;
		НовыйЭлемент.Ширина = 23; 
		НовыйЭлемент.РастягиватьПоВертикали = Ложь; 
		НовыйЭлемент.РастягиватьПоГоризонтали = Ложь; 
		НовыйЭлемент.ПутьКДанным = Реквизит.Имя; 
		НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		НовыйЭлемент.УстановитьДействие("ПриНажатии", "Подключаемый_HTMLПриНажатии");
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьВиджетыТекущихДел()

//   Обновляет текущий виджет.
//
Процедура ОбновитьТекущийВиджет(Форма, ИндексВиджета) Экспорт
	
	Для Каждого ЭлементСпискаВиджетов Из Форма.СписокВиджетовПользователя Цикл
		тВиджет = ЭлементСпискаВиджетов.Значение;
		тИндекс = ЭлементСпискаВиджетов.Представление; 
		
		Если ИндексВиджета = тИндекс Тогда
			Форма["Виджет" + тИндекс] = ЗаполнитьHTMLПолеВиджета(тВиджет, тИндекс);
			Прервать;
		ИначеЕсли ИндексВиджета = "Прочие" И Число(тИндекс) > 4 Тогда
			Форма["Виджет" + тИндекс] = ЗаполнитьHTMLПолеВиджета(тВиджет, тИндекс);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ОбновитьТекущийВиджет()

//  Заполняет поле Виджета.
//
Функция ЗаполнитьHTMLПолеВиджета(Виджет, ИндексВиджета = "") Экспорт
	
	//УстановитьПривилегированныйРежим(Истина);
	
	Показатель = Виджет.ИсточникДанных;
	
	Заголовок = Показатель.КраткоеНаименование;
	Единица = Показатель.ЕдиницаИзмерения;
	
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	
	МенеджерЗаписи = РегистрыСведений.CRM_НастройкиВиджетов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Пользователь	 	= ТекущийПользователь;
	МенеджерЗаписи.Виджет 			= Виджет;
	МенеджерЗаписи.ИндексВиджета 	= ИндексВиджета;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() 
		И ИндексВиджета <> "" Тогда // Для виджета в АРМ Ключевых показателей - всегда по текущему пользователю.
		ТипАналитики = МенеджерЗаписи.ТипАналитики;
		ЗначениеАналитики = МенеджерЗаписи.ЗначениеАналитики;
	Иначе
		ТипАналитики = Перечисления.CRM_ВидыРазверткиПоказателей.Аналитика1;
		ЗначениеАналитики = ТекущийПользователь;
	КонецЕсли;
	Если ТипЗнч(ЗначениеАналитики) = Тип("СправочникСсылка.Пользователи") Тогда
		МассивМенеджеров = Новый Массив;
		МассивМенеджеров.Добавить(ЗначениеАналитики);
		МассивПодразделений = Неопределено;
	ИначеЕсли ТипЗнч(ЗначениеАналитики) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		МассивМенеджеров = Неопределено;
		МассивПодразделений = Новый Массив;
		МассивПодразделений.Добавить(ЗначениеАналитики);
	Иначе
		МассивМенеджеров = Неопределено;
		МассивПодразделений = Неопределено;
	КонецЕсли;
	ТаблицаДанных = CRM_УправлениеЦелевымиПоказателямиСервер.ПолучитьТаблицуПоказателя(Показатель, CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса(), МассивМенеджеров, МассивПодразделений);
	КонтролируемыйПоказатель = Показатель.КонтролируемыйПоказатель;
	
	Если КонтролируемыйПоказатель = "" Тогда
		Возврат "";
	КонецЕсли;
	ПланНеУстановлен = ТаблицаДанных[0].ЗначениеПоказателя = Null;
	Если ТаблицаДанных.Колонки.Найти(КонтролируемыйПоказатель) = Неопределено Тогда
		ЗначениеПоказателя	= 0;
		Цель				= 0;
		ЦветПоказателя		= 0;
		ДинамикаПоказателя	= Новый Структура();
		ДинамикаПоказателя.Вставить("Тренд", 0);
	Иначе	
		ЗначениеПоказателя	= ТаблицаДанных.Итог(КонтролируемыйПоказатель);
		Цель				= ТаблицаДанных.Итог("ЗначениеПоказателя");
		ЦветПоказателя		= CRM_УправлениеЦелевымиПоказателямиСервер.ПолучитьЦветПоказателя(Показатель, CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса(), ТекущийПользователь,, ТаблицаДанных);
		ДинамикаПоказателя	= CRM_УправлениеЦелевымиПоказателямиСервер.ПолучитьДинамикуПоказателя(Показатель, CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса(), ТекущийПользователь);
	КонецЕсли;
	Возврат HTMLПредставлениеВиджета(Заголовок, Единица, ЗначениеПоказателя, Цель, ЦветПоказателя, ДинамикаПоказателя, ИндексВиджета <> "", ПланНеУстановлен);
	
КонецФункции // ЗаполнитьHTMLПолеВиджета()

//   Обрабатывает данные по настройке.
//
Функция ОбработатьДанныеПоНастройкеВиджета(Таблица, ТипАналитики, ЗначениеАналитики) Экспорт
	
	ОтборМассив = Новый Массив;
	
	Если ТипАналитики = Перечисления.CRM_ВидыРазверткиПоказателей.НеИспользовать Тогда
		Таблица.Свернуть("Показатель", "Значение");
		Для Каждого СтрокаТЗ Из Таблица Цикл
			ОтборМассив.Добавить(СтрокаТЗ);
		КонецЦикла;
	ИначеЕсли ТипАналитики = Перечисления.CRM_ВидыРазверткиПоказателей.Подразделение Тогда
		Таблица.Свернуть("Подразделение", "Значение");
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таблица.Подразделение,
		|	Таблица.Значение
		|ПОМЕСТИТЬ Выборка
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(Выборка.Значение), 0) КАК Значение
		|ИЗ
		|	Выборка КАК Выборка
		|ГДЕ
		|	Выборка.Подразделение В
		|			(ВЫБРАТЬ
		|				СтруктураПредприятия.Ссылка КАК Ссылка
		|			ИЗ
		|				Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|			ГДЕ
		|				СтруктураПредприятия.Ссылка В ИЕРАРХИИ (&Ссылка))";
		Запрос.УстановитьПараметр("Ссылка", ЗначениеАналитики);
		Запрос.УстановитьПараметр("Таблица", Таблица);
		
		РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		Для Каждого СтрокаТЗ Из РезультатЗапроса Цикл
			ОтборМассив.Добавить(СтрокаТЗ);
		КонецЦикла;
	ИначеЕсли ТипАналитики = Перечисления.CRM_ВидыРазверткиПоказателей.Аналитика1 Тогда
		Таблица.Свернуть("Аналитика1", "Значение");
		ОтборМассив = Таблица.НайтиСтроки(Новый Структура("Аналитика1", ЗначениеАналитики));
	КонецЕсли;
	
	Возврат ОтборМассив;
	
КонецФункции // ОбработатьДанныеПоНастройкеВиджета()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ФормированиеHTMLПредставленияВиджета

// Возвращает html представление виджета.
//
// Параметры:
//   Заголовок - Строка - html текст заголовка виджета.
//   Подвал - Строка - html текст подвала виджета.
//   ТелоВиджета - Строка - html текст тела виджета.
//   ФонаВиджета - Строка - цвет фона виджета в виде шестнадцатеричного значения.
//   ЦветРамкиТаблицы - Строка - цвет рамок таблиц в виджете, в виде шестнадцатеричного значения.
//
// Возвращаемое значение:
//   Строка - html представление виджета.
//
Функция HTMLПредставлениеВиджета(Заголовок = "", Единица = "", ЗначениеПоказателя, Цель, ЦветПоказателя, ДинамикаПоказателя, ОтображатьНастройки, ПланНеУстановлен)
	
	//УспешностьВиджета = ?(ДинамикаУспех <> Неопределено, ДинамикаУспех, РезультатУспех);
	//УспешностьВиджета =  ;
	ЗначениеСтрокой = Формат(ЗначениеПоказателя,"ЧДЦ=; ЧН=0; ЧГ=0");
	ДлинаЗначения = СтрДлина(ЗначениеСтрокой);
	ЗначениеПорядок = "";
	Если ДлинаЗначения > 3 И ДлинаЗначения <= 6 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' тыс'");
	ИначеЕсли ДлинаЗначения > 6 И ДлинаЗначения <= 9 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' млн'");
	ИначеЕсли ДлинаЗначения > 9 И ДлинаЗначения <= 12 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000000000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' млрд'");
	ИначеЕсли ДлинаЗначения > 12 И ДлинаЗначения <= 15 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000000000000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' блн'");
	ИначеЕсли ДлинаЗначения > 15 И ДлинаЗначения <= 18 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000000000000000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' блрд'");
	ИначеЕсли ДлинаЗначения > 18 И ДлинаЗначения <= 21 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000000000000000000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' трн'");
	ИначеЕсли ДлинаЗначения > 21 И ДлинаЗначения <= 24 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000000000000000000000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' тррд'");
	ИначеЕсли ДлинаЗначения > 24 И ДлинаЗначения <= 27 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000000000000000000000000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' кван'");
	ИначеЕсли ДлинаЗначения > 27 И ДлинаЗначения <= 30 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000000000000000000000000000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' квард'");
	ИначеЕсли ДлинаЗначения > 30 И ДлинаЗначения <= 33 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000000000000000000000000000000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' квин'");
	ИначеЕсли ДлинаЗначения > 33 И ДлинаЗначения <= 36 Тогда
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя/1000000000000000000000000000000000), "ЧДЦ=; ЧН=0; ЧГ=0");
		ЗначениеПорядок = НСтр("ru = ' квирд'");
	Иначе                             
		ЗначениеСтрокой = Формат(Окр(ЗначениеПоказателя), "ЧДЦ=; ЧН=0; ЧГ=0");
	КонецЕсли;
	
	ЕдиницаИзмеренияСтрокой = НРег(?(ЗначениеПорядок <> "", ЗначениеПорядок, "") + ?(Единица <> "", " " + Лев(Единица, 3), ""));
	ДвоичныеДанныеКартинки = БиблиотекаКартинок.CRM_ВиджетНастроить.ПолучитьДвоичныеДанные();
	Base64ДанныеКартинки = Base64Строка(ДвоичныеДанныеКартинки);
	КартинкаШестеренка = "data:image/" + БиблиотекаКартинок.CRM_ВиджетНастроить.Формат() + ";base64," + Base64ДанныеКартинки;
	
	ДвоичныеДанныеКартинки = БиблиотекаКартинок.CRM_ВиджетНастроитьАктивная.ПолучитьДвоичныеДанные();
	Base64ДанныеКартинки = Base64Строка(ДвоичныеДанныеКартинки);
	КартинкаШестеренкаАкт = "data:image/" + БиблиотекаКартинок.CRM_ВиджетНастроитьАктивная.Формат() + ";base64," + Base64ДанныеКартинки;
	
	HTMLТекст = "<html><head>
	|<style type=""text/css"">
	|	html {
	//|		width: 220px;
	//|		height: 80px;
	|		width: 100%;
	|		height: 100%;
	|";
	Если ПланНеУстановлен Тогда
		HTMLТекст = HTMLТекст + "border-width: 1px;
		|border-color: #e4e4e4;
		|";	
	Иначе	
		HTMLТекст = HTMLТекст + "border-width: " + ?(ЦветПоказателя = 0, "1px 1px 1px 3px", "1px") + ";
		|border-color: " + ?(ЦветПоказателя = 0, "#e4e4e4 #e4e4e4 #e4e4e4 #d34343", "#e4e4e4") + ";
		|";	
	КонецЕсли;
	HTMLТекст = HTMLТекст + "border-style: solid;
	|		}
	|	body {
	|		overflow: hidden;
	|		margin-top:  0px;
	|		margin-bottom: 0px;
	|		margin-left: 0px;
	|		margin-right: 0px;
	|		background-color: #f5f5f5;
	|		}
	|	a {
	|		text-decoration: none;
	|	}
	|	a.rollover {
	|		background: url(" + КартинкаШестеренка + "); /* Путь к файлу с исходным рисунком  */
	|		background-repeat: no-repeat;
	|		position: absolute;
	|		top: 5px;
	|		right: 5px;
	|		display: block; /*  Рисунок как блочный элемент */
	|		width: 16px; /* Ширина рисунка */
	|		height: 16px; /*  Высота рисунка */
	|	}
	|	a.rollover:hover {
	|		background: url(" + КартинкаШестеренкаАкт + "); /* Путь к файлу с заменяемым рисунком  */
	|		background-repeat: no-repeat;
	|	}
	|	.bottomdiv {
	|		position: fixed;
	|		bottom: 4px;
	|		right: 6px;
	//|		width: 220px;
	|		width: 100%;
	|		text-align: right;
	|		vertical-align: bottom;
	|		height: 8px;
	|	}
	|	.bottomdivnew {
	|		position: fixed;
	|		bottom: 4px;
	|		right: 6px;
	//|		width: 220px;
	|		width: 100%;
	|		text-align: left;
	|		vertical-align: bottom;
	|		height: 8px;
	|	}
	|</style>
	|<body>";
	
	// группа Настройка
	//HTMLТекст = HTMLТекст + "<a href=""РасшифроватьЗначение"">";
	
	HTMLТекст = HTMLТекст + "<table width=""100%"" height=""20%"">";
	HTMLТекст = HTMLТекст + "<tr>";
	HTMLТекст = HTMLТекст + "<td width=""93%"">";
	Если ПланНеУстановлен Тогда
		HTMLТекст = HTMLТекст + "<font face=""Arial"" size=""1"" color=""#888888"">";
		HTMLТекст = HTMLТекст + "План не установлен";
		HTMLТекст = HTMLТекст + "</font>";
	КонецЕсли;	
	HTMLТекст = HTMLТекст + "</td>";
	HTMLТекст = HTMLТекст + "<td width=""7%"">";
	Если ОтображатьНастройки Тогда
		HTMLТекст = HTMLТекст + "<a href=""НастройкаВиджета"" class=""rollover""></a>";
	Иначе
		HTMLТекст = HTMLТекст + "&nbsp";
	КонецЕсли;
	HTMLТекст = HTMLТекст + "</td></tr></table>";
	
	// основная группа
	//   R  G  B
	// #B2 22 22 - красный цвет
	// #FF 8C 00 - желтый цвет
	// #3C B3 71 - зеленый цвет

	HTMLТекст = HTMLТекст + "<table width=""100%"" height=""60%"">";
	HTMLТекст = HTMLТекст + "<tr>";
	//HTMLТекст = HTMLТекст + "<td width=""85px"" height=""64px"" align=""center"">";
	HTMLТекст = HTMLТекст + "<td width=""39%"" align=""center"">";
	Если ЦветПоказателя = 0 Тогда
		HTMLТекст = HTMLТекст + "<font face=""Arial"" size=""6"" color=""#B22222"">";
	ИначеЕсли ЦветПоказателя = 1 Тогда
		HTMLТекст = HTMLТекст + "<font face=""Arial"" size=""6"" color=""#FF8C00"">";
	ИначеЕсли ЦветПоказателя = 2 Тогда
		HTMLТекст = HTMLТекст + "<font face=""Arial"" size=""6"" color=""#3CB371"">";
	КонецЕсли;	
	Если ПланНеУстановлен Тогда
		HTMLТекст = HTMLТекст + "<font face=""Arial"" size=""6"" color=""#888888"">";
	КонецЕсли;	
	HTMLТекст = HTMLТекст + ЗначениеСтрокой;
	HTMLТекст = HTMLТекст + "</font>";
	//HTMLТекст = HTMLТекст + "</td>";
	Если НЕ ПланНеУстановлен Тогда
		//HTMLТекст = HTMLТекст + "<td width=""20px"" height=""64px"" align=""center"">";
		Если ДинамикаПоказателя.Тренд = -1 Тогда
			ДобавитьКартинку(HTMLТекст, БиблиотекаКартинок.CRM_ВиджетыДинамикаОтрицательнаяВниз);
		ИначеЕсли ДинамикаПоказателя.Тренд = 0 Тогда
			ДобавитьКартинку(HTMLТекст, БиблиотекаКартинок.CRM_ВиджетыДинамикаНет);
		ИначеЕсли ДинамикаПоказателя.Тренд = 1 Тогда
			ДобавитьКартинку(HTMLТекст, БиблиотекаКартинок.CRM_ВиджетыДинамикаПоложительнаяВверх);
		КонецЕсли;
	КонецЕсли;	
			
	//HTMLТекст = HTMLТекст + "<br>";
	HTMLТекст = HTMLТекст + "</td>";
	
	// заголовок виджета
	//HTMLТекст = HTMLТекст + "<td width=""115px"" height=""64px"" align=""left"">";
	HTMLТекст = HTMLТекст + "<td width=""52%"" align=""left"">";
	HTMLТекст = HTMLТекст + "<font face=""Arial"" size=""1"" color=""#666666"">";
	HTMLТекст = HTMLТекст + Заголовок + ?(ЕдиницаИзмеренияСтрокой <> "", ", " + ЕдиницаИзмеренияСтрокой, "");
	HTMLТекст = HTMLТекст + "</font>";
	HTMLТекст = HTMLТекст + "</td></tr></table>";
	
	HTMLТекст = HTMLТекст + "<table width=""100%"" height=""20%"">";
	HTMLТекст = HTMLТекст + "<tr width=""100%"">";
	HTMLТекст = HTMLТекст + "<td align=""left"" width=""50%"">";
	// группа Расшифровать
	//HTMLТекст = HTMLТекст + "<div class=""bottomdivnew"">";
	HTMLТекст = HTMLТекст + "<font face=""Arial"" size=""1"" color=""#0066cc"">";
	HTMLТекст = HTMLТекст + "<a href=""Расшифровать"">" + НСтр("ru = 'Расшифровать'") + "</a>";
	HTMLТекст = HTMLТекст + "</font>";
	//HTMLТекст = HTMLТекст + "</div>";
	HTMLТекст = HTMLТекст + "</td>";	
	// группа Обновить
	HTMLТекст = HTMLТекст + "<td align=""right"" width=""50%"">";
	//HTMLТекст = HTMLТекст + "<div class=""bottomdiv"">";
	HTMLТекст = HTMLТекст + "<font face=""Arial"" size=""1"" color=""#0066cc"">";
	HTMLТекст = HTMLТекст + "<a href=""Обновить"">" + НСтр("ru = 'Обновить'") + "</a>";
	HTMLТекст = HTMLТекст + "</font>";
		
	//HTMLТекст = HTMLТекст + "</div>";
	HTMLТекст = HTMLТекст + "</td>";
	HTMLТекст = HTMLТекст + "</tr>";
	HTMLТекст = HTMLТекст + "</table>";
	//// белая полоса внизу
	//HTMLТекст = HTMLТекст + "<table><tr height=""1px"" bgcolor=""#ffffff""></tr></table>";
	
	//HTMLТекст = HTMLТекст + "</a>";
	HTMLТекст = HTMLТекст + "</body></html>";
	
	УдалитьВредоносныйКодИзТекста(HTMLТекст);
	
	Возврат HTMLТекст;
	
КонецФункции // HTMLПредставлениеВиджета()


// Добавляет ссылку в текст html.
//
// Параметры:
//   HTMLТекст - Строка - текст html.
//   ТекстСсылки - Текст ссылки.
//   Ссылка - Строка - ссылки для вставки в тег <a>.
//
Процедура ДобавитьСсылку(HTMLТекст, ТекстСсылки, Ссылка = "") Экспорт
	
	Если ЗначениеЗаполнено(ТекстСсылки) Тогда
		HTMLТекст = HTMLТекст + "<a href=" + Ссылка + ">";
	КонецЕсли;
	
	HTMLТекст = HTMLТекст + ТекстСсылки;
		
	Если ЗначениеЗаполнено(Ссылка) Тогда
		HTMLТекст = HTMLТекст + "</a>";
	КонецЕсли;
	
КонецПроцедуры // ДобавитьСсылку()

// Добавляет значение любого типа в текст html.
// Если в процедуру передается ссылочный тип данных, то в текст html.
// Добавляется навигационная ссылка с представлением переданного значения.
//
// Параметры:
//   HTMLТекст - Строка - текст html.
//   Значение - Любой тип - значение реквизита.
//   Цвет - строка – шестнадцатеричное представление цвета (например: E9B7FF) значения реквизита.
//
Процедура ДобавитьЗначение(HTMLТекст, ЗначениеДанных, Цвет = "") Экспорт
	
	Значение = ЗначениеДанных;
	
	Если ТипЗнч(Значение) = Тип("Строка") Тогда 
		Если ЗначениеЗаполнено(Цвет) Тогда 
			HTMLТекст = HTMLТекст + "<FONT color=#"+Цвет+">";
			HTMLТекст = HTMLТекст + CRM_РаботаСHTML.ЗаменитьСпецСимволыHTML(Значение);
			HTMLТекст = HTMLТекст + "</FONT>";
		Иначе	
			HTMLТекст = HTMLТекст + CRM_РаботаСHTML.ЗаменитьСпецСимволыHTML(Значение);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Дата")
		Или ТипЗнч(Значение) = Тип("Число")
		Или ТипЗнч(Значение) = Тип("Булево") Тогда 
		CRM_РаботаСHTML.ЗаменитьСпецСимволыHTML(Значение);
		
		Если ЗначениеЗаполнено(Цвет) Тогда 
			HTMLТекст = HTMLТекст + "<FONT color=#"+Цвет+">";
			HTMLТекст = HTMLТекст + Значение;
			HTMLТекст = HTMLТекст + "</FONT>";
		Иначе	
			HTMLТекст = HTMLТекст + Значение;
		КонецЕсли;	
	Иначе
		HTMLТекст = HTMLТекст + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<A href=v8doc:%1>%2</A>",
			ПолучитьНавигационнуюСсылку(Значение),
			CRM_РаботаСHTML.ЗаменитьСпецСимволыHTML(Строка(Значение)));
	КонецЕсли;
	
КонецПроцедуры // ДобавитьЗначение()

// Добавляет картинку в текст html.
//
// Параметры:
//   HTMLТекст - Строка - текст html.
//   Картинка - Картинка.
//   Ссылка - Строка - ссылки для вставки в тег <a>.
//
Процедура ДобавитьКартинку(HTMLТекст, Картинка, Ссылка = "") Экспорт
	
	ДвоичныеДанныеКартинки = Картинка.ПолучитьДвоичныеДанные();
	Base64ДанныеКартинки = Base64Строка(ДвоичныеДанныеКартинки);
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		HTMLТекст = HTMLТекст + "<a href=" + Ссылка + ">";
	КонецЕсли;
	
	HTMLТекст = HTMLТекст
		+ "<img src='data:image/"
		+ Картинка.Формат()
		+ ";base64,"
		+ Base64ДанныеКартинки + "'; border = ""0"";>";
		
	Если ЗначениеЗаполнено(Ссылка) Тогда
		HTMLТекст = HTMLТекст + "</a>";
	КонецЕсли;
	
КонецПроцедуры // ДобавитьКартинку()

// Удаляет вредоносный код html из текста.
//
// Параметры:
//   Текст - Строка - текст.
//
Процедура УдалитьВредоносныйКодИзТекста(Текст) Экспорт
	
	НРегТекст = НРег(Текст);
	
	МассивСтрокБезВредоносногоТекста = Новый Массив;
	
	// Удаление скриптов
	НомерСкрипта = 1;
	ПозицияНачалаОбработки = 1;
	
	Пока Истина Цикл
		
		ПозицияНачалаОткрывающегоТегаScript = СтрНайти(НРегТекст, "<script",,, НомерСкрипта);
		ПозицияНачалаЗакрывающегоТегаScript = СтрНайти(НРегТекст, "</script",,, НомерСкрипта);
		
		Если ПозицияНачалаОткрывающегоТегаScript = 0 Или ПозицияНачалаЗакрывающегоТегаScript = 0 Тогда
			Прервать;
		КонецЕсли;
		
		ПозицияОкончанияОткрывающегоТегаScript = СтрНайти(НРегТекст, ">",, ПозицияНачалаОткрывающегоТегаScript + 1);
		ПозицияОкончанияЗакрывающегоТегаScript = СтрНайти(НРегТекст, ">",, ПозицияНачалаЗакрывающегоТегаScript + 1);
		
		Если ПозицияОкончанияОткрывающегоТегаScript = 0 Или ПозицияОкончанияЗакрывающегоТегаScript = 0 Тогда
			Прервать;
		КонецЕсли;
		
		// Добавим текст до скрипта
		ТекстДоСкрипта = Сред(Текст, ПозицияНачалаОбработки, ПозицияНачалаОткрывающегоТегаScript - ПозицияНачалаОбработки);
		МассивСтрокБезВредоносногоТекста.Добавить(ТекстДоСкрипта);
		
		ПозицияНачалаОбработки = ПозицияОкончанияЗакрывающегоТегаScript + 1;
		НомерСкрипта = НомерСкрипта + 1;
		
	КонецЦикла;
	
	Если МассивСтрокБезВредоносногоТекста.Количество() > 0 Тогда
		
		// Добавим текст после последнего скрипта.
		ТекстДоСкрипта = Сред(Текст, ПозицияНачалаОбработки);
		МассивСтрокБезВредоносногоТекста.Добавить(ТекстДоСкрипта);
		
		// Сформируем итоговую строку без скрипта.
		Текст = СтрСоединить(МассивСтрокБезВредоносногоТекста);
	КонецЕсли;
	
КонецПроцедуры // УдалитьВредоносныйКодИзТекста()

#КонецОбласти

#Область ЗаполнениеКлючевыхПоказателейВиджетов

//   Запрос по умолчанию.
//
Функция ВосстановитьЗапросПоУмолчанию(Показатель) Экспорт
	
	//ТабличныйМакет = ПолучитьОбщийМакет("CRM_МакетЗапросовКлючевыхПоказателей");
	//тСтрока = 1;
	//Пока тСтрока <= ТабличныйМакет.ВысотаТаблицы Цикл
	//	тТекст = ТабличныйМакет.Область(тСтрока, 1).Текст;
	//	Если тТекст = Показатель.ИмяПредопределенныхДанных Тогда
	//		тЗапрос = ТабличныйМакет.Область(тСтрока, 2).Текст;
	//		Возврат тЗапрос;
	//	КонецЕсли;
	//	тСтрока = тСтрока + 1;
	//КонецЦикла;
	
КонецФункции // ВосстановитьЗапросПоУмолчанию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьЗначениеАналитикиИзНастроекВиджета(Виджет, ИндексВиджета = "", Пользователь) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.CRM_НастройкиВиджетов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Пользователь	 	= Пользователь;
	МенеджерЗаписи.Виджет 			= Виджет;
	МенеджерЗаписи.ИндексВиджета 	= ИндексВиджета;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() 
		И ИндексВиджета <> "" Тогда
		ЗначениеАналитики = МенеджерЗаписи.ЗначениеАналитики;
	Иначе
		ЗначениеАналитики = Пользователь;
	КонецЕсли;
	Возврат ЗначениеАналитики;
	
КонецФункции // HTMLПредставлениеВиджета()

#КонецОбласти
