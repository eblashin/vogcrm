
// Процедура создает пользовательскую цветовую категорию по номеру цвета и наименованию.
//
// Параметры:
//	Пользователь	- СправочникСсылка	- Пользователь
//	Наименование	- Строка			- Наименование
//	нЦвет			- Число, Цвет		- Цвет.
//
Процедура CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, Наименование, нЦвет)
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда Возврат; КонецЕсли;
	НайденнаяЦветоваяГруппа = Справочники.CRM_КатегорииПользователей.НайтиПоНаименованию(Наименование, Истина, , Пользователь);
	Если НЕ ЗначениеЗаполнено(НайденнаяЦветоваяГруппа) Тогда
		СтруктураЦвет = CRM_ОбщегоНазначенияКлиентСервер.ПолучитьЦветПоКлючу(нЦвет);
		Если НЕ (СтруктураЦвет = Неопределено) Тогда
			НоваяКатегория = Справочники.CRM_КатегорииПользователей.СоздатьЭлемент();
			НоваяКатегория.Владелец		= Пользователь;
			НоваяКатегория.Наименование	= Наименование;
			НоваяКатегория.ЦветКрасный	= СтруктураЦвет.Цвет.Красный;
			НоваяКатегория.ЦветСиний	= СтруктураЦвет.Цвет.Синий;
			НоваяКатегория.ЦветЗеленый	= СтруктураЦвет.Цвет.Зеленый;
			НоваяКатегория.ЦветИндекс	= нЦвет;
			НоваяКатегория.Записать();
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры // CRM_СоздатьЦветовуюГруппуПользователя)
	
// Процедура заполняет пользователя предопределенными цветовыми гпруппами.
//
// Параметры:
//	Пользователь	- СправочникСсылка	- Пользователь.
//
Процедура CRM_ЗаполнитьПредопределеннымиЦветовымиГруппами(Пользователь)
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru = 'Длительные проекты'"),	7);
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru = 'Мелкие задачи'"),		4);
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru = 'Задачи в офисе'"),		24);
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru = 'От шефа'"),				15);
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru = 'Приятные задачи'"),		0);
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru = 'Личные'"),				8);
КонецПроцедуры // CRM_ЗаполнитьПредопределеннымиЦветовымиГруппами()
 
// Процедура заполняет настройки пользователя по умолчанию.
// 
// Параметры:
//	Пользователь	- СправочникСсылка	- Пользователь.
//
Процедура CRM_ЗаполнитьНастройкиПользователяПоУмолчанию(Пользователь) Экспорт
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда Возврат; КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	CRM_ОбщегоНазначенияСервер.УстановитьНастройкуПользователя(Пользователь,								"ОсновнойОтветственный",				Пользователь);
	CRM_ОбщегоНазначенияСервер.УстановитьНастройкуПользователя(CRM_ОбщегоНазначенияСервер.ПолучитьПредопределеннуюОрганизацию(), "ОсновнаяОрганизация",					Пользователь);
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Пользователь.ИдентификаторПользователяИБ);
	CRM_ЗаполнитьПредопределеннымиЦветовымиГруппами(Пользователь);
	Если НЕ (ПользовательИБ = Неопределено) Тогда
		// Настройки поля отображения содержания.
		CRM_ОбщегоНазначенияСервер.НастройкиПолейОтображенияСодержанияЗагрузитьИзМакета(, ПользовательИБ.Имя);
	КонецЕсли;
	
	// Настройки оповещений
	НаборЗаписей = РегистрыСведений.CRM_ОповещенияПользовательскиеНастройки.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	// 1. Значимые события
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ЗавершениеБизнесПроцесса;
	Запись.Напоминание		= Истина;
	
	// Отложено до след. релиза
	//Запись = НаборЗаписей.Добавить();
	//Запись.Пользователь		= Пользователь;
	//Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещатьОНовыхВходящихПисьмах;
	//Запись.Напоминание		= Истина;
	//Запись.СрокОповещения	= 30;
	//Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.Минута;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ПросроченныеНеЗавершенныеСобытияЗадачи;
	Запись.Напоминание		= Истина;
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ПросроченныеКонтрольныеТочки;
	Запись.Напоминание		= Истина;
	
	// 2. Оповещения о событиях/задачах.
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещатьОНовыхЗадачах;
	Запись.Напоминание		= Истина;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещатьОПереадресованныхДокументахЗадачах;
	Запись.Напоминание		= Истина;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещатьОНовыхВходящихПисьмах;
	Запись.СрокОповещения = 10;
	Запись.Периодичность = Перечисления.CRM_ПериодичностьОповещений.Минута;
	
	// 3. Запланированные события
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.Оповещение_1;
	Запись.Напоминание		= Ложь;
	//Запись.СрокОповещения	= 10;
	//Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.Минута;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.Оповещение_2;
	Запись.ЭлектроннаяПочта	= Ложь;
	//Запись.СрокОповещения	= 1;
	//Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.Час;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.Оповещение_3;
	Запись.СМС				= Ложь;
	//Запись.СрокОповещения	= 10;
	//Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.Минута;
	
	// 4. Дни рождения
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещенияОДняхРождения;
	Запись.Напоминание		= Истина;
	Запись.СрокОповещения	= 1;
	Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.День;
	
	НаборЗаписей.Записать();
	
	// 5. Заполнение пользовательских настроек динамических списков по умолчанию.
	Если НЕ (ПользовательИБ = Неопределено) Тогда
		CRM_ОбщегоНазначенияСервер.ПользовательскиеНастройкиСпискаЗаполнитьПоУмолчанию(, ПользовательИБ.Имя);
	КонецЕсли;
	
	// 6. Заполнение пользовательских настроек работы с почтой по умолчанию.
	Если НЕ (ПользовательИБ = Неопределено) Тогда
		CRM_УправлениеЭлектроннойПочтой.ЗаполнитьНастройкиРаботыСПочтойПоУмолчанию(ПользовательИБ.Имя);
	КонецЕсли;
	
КонецПроцедуры // CRM_ЗаполнитьНастройкиПользователяПоУмолчанию()

// Процедура заполняет настройки всех пользователей по умолчанию.
// 
// Параметры:
//	Нет.
//
Процедура CRM_ЗаполнитьНастройкиВсехПользователейПоУмолчанию() Экспорт
	ПустойУникальныйИдентификатор = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.ПометкаУдаления
	|	И Пользователи.ИдентификаторПользователяИБ <> &ПустойУникальныйИдентификатор
	|");
	Запрос.УстановитьПараметр("ПустойУникальныйИдентификатор", ПустойУникальныйИдентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		CRM_ЗаполнитьНастройкиПользователяПоУмолчанию(Выборка.Ссылка);
	КонецЦикла;
КонецПроцедуры // CRM_ЗаполнитьНастройкиВсехПользователейПоУмолчанию()
