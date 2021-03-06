
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьКэшОформления(ПараметрыКэша, КэшОформления) Экспорт

	Если Не ПараметрыКэша.Свойство("Настройка") Тогда
		ПараметрыКэша.Вставить("Настройка", Константы.вогНастройкаЗанятости.Получить());
		
	КонецЕсли;
	
	СхемаИНастройки = Справочники.вогНастройкиЗанятости.ОписаниеИСхемаКомпоновкиДанныхНастройкиПоИмениМакета(ПараметрыКэша.Настройка, ПараметрыКэша.Настройка.СхемаКомпоновкиДанных);
	
	//Параметры
	СхемаКомпоновкиДанныхПараметры = СхемаИНастройки.СхемаКомпоновкиДанных.Параметры;

	СхемаКомпоновкиДанныхПараметры.НачалоПериода.Значение = ПараметрыКэша.НачалоПериода;
	СхемаКомпоновкиДанныхПараметры.КонецПериода.Значение  = ПараметрыКэша.КонецПериода;
	
	СхемаКомпоновкиДанныхПараметры.Настройка.Значение  	 = ПараметрыКэша.Настройка;
	СхемаКомпоновкиДанныхПараметры.Пользователь.Значение = ПараметрыКэша.Пользователь;
	
	РабочееВремяСекунд = ((ПараметрыКэша.НастройкиОтображения.КонецРабочегоДняЧас - ПараметрыКэша.НастройкиОтображения.НачалоРабочегоДняЧас) - 
		(ПараметрыКэша.НастройкиОтображения.КонецОбеденногоПерерываЧас - ПараметрыКэша.НастройкиОтображения.НачалоОбеденногоПерерываЧас)) * 3600;
		
	НачалоРабочегоДняСекунд = ПараметрыКэша.НастройкиОтображения.НачалоРабочегоДняЧас * 3600;	
		
	СхемаКомпоновкиДанныхПараметры.РабочееВремя.Значение      = РабочееВремяСекунд;
	СхемаКомпоновкиДанныхПараметры.НачалоРабочегоДня.Значение = НачалоРабочегоДняСекунд;
	
	URLСхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаИНастройки.СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	НовыйИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемаКомпоновкиДанных);
	
	// Восстановим пользовательские настройки отборов
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(НовыйИсточникДоступныхНастроек);
	Если НЕ СхемаИНастройки.НастройкиКомпоновкиДанных = Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаИНастройки.НастройкиКомпоновкиДанных);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаИНастройки.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ТаблицаДанных = ТаблицаСКД(СхемаИНастройки.СхемаКомпоновкиДанных, Настройки);
	Если ТаблицаДанных.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаДанных Из ТаблицаДанных Цикл
		СтрокаКэша = КэшОформления.Добавить();	
		СтрокаКэша.День = СтрокаДанных.День;
		СтрокаКэша.Цвет = вогНастройкиЗанятостиПовтИсп.ЗначениеЦвета(СтрокаДанных.Цвет);
	
	КонецЦикла;
		
КонецПроцедуры

Функция ТаблицаСКД(СКД, Настройки)

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СКД,Настройки,,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")
	);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаЗначений);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат ТаблицаЗначений;

КонецФункции

Функция СформироватьЛегендуПоНастройке(Форма, НастройкаСсылка, СтруктураРазмещения, Исключения) Экспорт
	
	МассивЭлементовУдаления = Новый Массив;
	Для каждого КлючЗначениеРазмещения Из СтруктураРазмещения Цикл
		Для каждого Элемент Из КлючЗначениеРазмещения.Значение.ПодчиненныеЭлементы Цикл
			Если Исключения.Найти(Элемент) = Неопределено Тогда
				МассивЭлементовУдаления.Добавить(Элемент);
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЦикла;
	
	Для каждого ЭлементУдаления Из МассивЭлементовУдаления Цикл
		Форма.Элементы.Удалить(ЭлементУдаления);
	
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Настройка", НастройкаСсылка);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПараметрыНаВесьДень.ВидВзаимодействия.Представление КАК ЗаголовокЭлемента,
		|	""ОбластьНаВесьДень"" КАК Область,
		|	ПараметрыНаВесьДень.Цвет,
		|	0 КАК Порядок,
		|	ПараметрыНаВесьДень.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Справочник.вогНастройкиЗанятости.ПараметрыНаВесьДень КАК ПараметрыНаВесьДень
		|ГДЕ
		|	ПараметрыНаВесьДень.Ссылка = &Настройка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПараметрыВПределахДня.НаименованиеИнтервала,
		|	""ОбластьВПределахДня"",
		|	ПараметрыВПределахДня.Цвет,
		|	2,
		|	ПараметрыВПределахДня.НомерСтроки
		|ИЗ
		|	Справочник.вогНастройкиЗанятости.ПараметрыВПределахДня КАК ПараметрыВПределахДня
		|ГДЕ
		|	ПараметрыВПределахДня.Ссылка = &Настройка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок,
		|	НомерСтроки";
	
	Сч = 0;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ГруппаЭлементаЛегенды = СоздатьНайтиОбычнуюГруппу(Форма, "ГруппаЭлементаЛегенды_" + Формат(Сч, "ЧГ="), 
			СтруктураРазмещения[Выборка.Область], 
			ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная);
			
		Элемент          = Форма.Элементы.Добавить( "ЦветЭлементаЛегенды_" + Формат(Сч, "ЧГ="), Тип("ДекорацияФормы"), ГруппаЭлементаЛегенды);
		Элемент.Вид      = ВидДекорацииФормы.Надпись;
		Элемент.ЦветФона = вогНастройкиЗанятостиПовтИсп.ЗначениеЦвета(Выборка.Цвет);
		Элемент.Рамка    = Новый Рамка(ТипРамкиЭлементаУправления.Одинарная, 1);
		Элемент.Ширина   = 4;
		Элемент.Высота   = 2;
		
		Элемент           = Форма.Элементы.Добавить( "ЗаголовокЭлементаЛегенды_" + Формат(Сч, "ЧГ="), Тип("ДекорацияФормы"), ГруппаЭлементаЛегенды);
		Элемент.Вид       = ВидДекорацииФормы.Надпись;
		Элемент.Заголовок = Выборка.ЗаголовокЭлемента;
		
		Сч = Сч + 1;	
			
	КонецЦикла;
		
КонецФункции // СформироватьЛегендуПоНастройке()

Функция СоздатьНайтиОбычнуюГруппу(Форма,
								  ИмяГруппы,
						   		  Родитель = Неопределено,
						   		  Группировка = Неопределено,
						   		  Отображение = Неопределено, 
						   		  РастягиватьПоГоризонтали = Неопределено,
						   		  РастягиватьПоВертикали = Неопределено,
						   		  ЗаголовокГруппы = "")
						   	
	Группа = Форма.Элементы.Найти(ИмяГруппы);
	Если Группа = Неопределено Тогда
		Группа   		   		  		= Форма.Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"), ?(Родитель = Неопределено, Форма, Родитель));	
		Группа.Вид		   		  		= ВидГруппыФормы.ОбычнаяГруппа;	
		Группа.Группировка 		  		= ?(Группировка = Неопределено, ГруппировкаПодчиненныхЭлементовФормы.Вертикальная, Группировка);
		Группа.Отображение 		   		= ?(Отображение = Неопределено, ОтображениеОбычнойГруппы.Нет, Отображение);
		Группа.РастягиватьПоГоризонтали = РастягиватьПоГоризонтали;
		Группа.РастягиватьПоВертикали   = РастягиватьПоВертикали;   
		Группа.ОтображатьЗаголовок 		= ЗначениеЗаполнено(ЗаголовокГруппы);	
		Группа.Заголовок 				= ЗаголовокГруппы;
					
	КонецЕсли;
	
	Возврат Группа;	
	
КонецФункции // СоздатьНайтиГруппу()

#Область ДиаграммаСложностиЗадач

Процедура ЗаполнитьДиаграммуСложностиЗадач(Диаграмма, Параметры) Экспорт
	
	Диаграмма.Обновление = Ложь;
	Диаграмма.Очистить();
	Диаграмма.ВидПодписей = ВидПодписейКДиаграмме.Нет;
		
	Запрос = Новый Запрос;
	
	ТаблицаПериодов = вогОбщегоНазначения.ПолучитьТаблицуПериодов(Параметры.НачалоПериода, Параметры.КонецПериода, 
		Перечисления.Периодичность.День);	
	
	Запрос.УстановитьПараметр("НачалоПериода"  , Параметры.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода"   , Параметры.КонецПериода);
	Запрос.УстановитьПараметр("Пользователь"   , Параметры.Пользователь);
	Запрос.УстановитьПараметр("ТаблицаПериодов", ТаблицаПериодов);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаПериодов.Период КАК Период
		|ПОМЕСТИТЬ ТаблицаПериодов
		|ИЗ
		|	&ТаблицаПериодов КАК ТаблицаПериодов
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ВЫБОР
		|			КОГДА ЗадачаИсполнителя.Выполнена
		|				ТОГДА ЗадачаИсполнителя.ДатаИсполнения
		|			ИНАЧЕ ЗадачаИсполнителя.СрокИсполнения
		|		КОНЕЦ, ДЕНЬ) КАК Дата,
		|	ЗадачаИсполнителя.БизнесПроцесс.вогСложность КАК Сложность,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗадачаИсполнителя.Ссылка) КАК КоличествоЗадач
		|ПОМЕСТИТЬ ДанныеСложностиЗадач
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.Исполнитель = &Пользователь
		|	И ВЫБОР
		|			КОГДА ЗадачаИсполнителя.Выполнена
		|				ТОГДА ЗадачаИсполнителя.ДатаИсполнения
		|			ИНАЧЕ ЗадачаИсполнителя.СрокИсполнения
		|		КОНЕЦ МЕЖДУ &НачалоПериода И &КонецПериода
		|	И НЕ ЗадачаИсполнителя.БизнесПроцесс.КартаМаршрута.вогЯвляетсяСогласованием = ИСТИНА
		|
		|СГРУППИРОВАТЬ ПО
		|	НАЧАЛОПЕРИОДА(ВЫБОР
		|			КОГДА ЗадачаИсполнителя.Выполнена
		|				ТОГДА ЗадачаИсполнителя.ДатаИсполнения
		|			ИНАЧЕ ЗадачаИсполнителя.СрокИсполнения
		|		КОНЕЦ, ДЕНЬ),
		|	ЗадачаИсполнителя.БизнесПроцесс.вогСложность
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаПериодов.Период,
		|	ДанныеСложностиЗадач.КоличествоЗадач,
		|	ЕСТЬNULL(ДанныеСложностиЗадач.Сложность, ЗНАЧЕНИЕ(Справочник.вогСложностьПоручений.ПустаяСсылка)) КАК Сложность
		|ИЗ
		|	ТаблицаПериодов КАК ТаблицаПериодов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеСложностиЗадач КАК ДанныеСложностиЗадач
		|		ПО ТаблицаПериодов.Период = ДанныеСложностиЗадач.Дата";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Серия = Диаграмма.УстановитьСерию(Выборка.Сложность);
		Серия.Текст = ?(Не ЗначениеЗаполнено(Выборка.Сложность), НСтр("ru = 'Не определена'"), Выборка.Сложность);
		
		Точка = Диаграмма.УстановитьТочку(Выборка.Период);
		Точка.Текст = Формат(Выборка.Период, Формат("ДФ=dd.MM.yy"));
		
		Диаграмма.УстановитьЗначение(Точка, Серия, ?(Выборка.КоличествоЗадач = null, 0, Выборка.КоличествоЗадач));
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Диаграмма.Обновление = Истина;	
	
КонецПроцедуры
	
#КонецОбласти

#КонецОбласти