&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ПутьКОбработке.Видимость = Объект.РежимОтладки;
	Элементы.ВыгрузитьОбработку.Видимость = НЕ Объект.РежимОтладки;
	Элементы.ЗагрузитьОбработку.Видимость = НЕ Объект.РежимОтладки;
	Элементы.ЗагрузитьСтандартнуюОбработку.Видимость = Объект.Предопределенный и НЕ Объект.РежимОтладки;	
	
	
	Элементы.НазваниеОбработки.Видимость = НЕ Объект.ИспользоватьСКД;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбъектОбработкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СписокОбъектов = ПолучитьСписокОбъектовДляОбработки();
	ОповещениеВыбора = Новый ОписаниеОповещения("ОбъектОбработкиНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОповещениеВыбора, СписокОбъектов, Элементы.ОбъектОбработкиПредставление);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбработкиНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		Объект.ОбъектОбработки = Результат.Значение;
		Объект.ОбъектОбработкиПредставление = Результат.Представление;
		СформироватьСКДПоОбъекту();
		Объект.Наименование = Объект.ТипОбъекта+"("+Объект.ОбъектОбработкиПредставление+")"+" - "+Объект.Событие;
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Функция ПолучитьСписокОбъектовДляОбработки()
	
	СписокОбъектов = Новый СписокЗначений;
	Если Объект.ТипОбъекта = "Документ" Тогда
		Для Каждого ЭлементВыборки Из Метаданные.Документы Цикл
			СписокОбъектов.Добавить(ЭлементВыборки.Имя, ЭлементВыборки.Синоним);
		КонецЦикла;	
	ИначеЕсли Объект.ТипОбъекта = "Справочник" Тогда
		Для Каждого ЭлементВыборки Из Метаданные.Справочники Цикл
			СписокОбъектов.Добавить(ЭлементВыборки.Имя, ЭлементВыборки.Синоним);
		КонецЦикла;	
	ИначеЕсли Объект.ТипОбъекта = "Бизнес-процесс" Тогда
		Для Каждого ЭлементВыборки Из Метаданные.БизнесПроцессы Цикл
			СписокОбъектов.Добавить(ЭлементВыборки.Имя, ЭлементВыборки.Синоним);
		КонецЦикла;	
	ИначеЕсли Объект.ТипОбъекта = "Задача" Тогда
		Для Каждого ЭлементВыборки Из Метаданные.Задачи Цикл
			СписокОбъектов.Добавить(ЭлементВыборки.Имя, ЭлементВыборки.Синоним);
		КонецЦикла;	
	КонецЕсли;	
	
	СписокОбъектов.СортироватьПоПредставлению();
	
	Возврат СписокОбъектов;
	
КонецФункции

&НаКлиенте
Процедура ПутьКОбработкеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Фильтр = "Файл обработки (*.epf)|*.epf";
	ДиалогВыбораФайла.Расширение = "html";
	
	ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Выберите файл'");
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
	ДиалогВыбораФайла.ИндексФильтра = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла = Объект.ПутьКОбработке;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = истина;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		
		Объект.ПутьКОбработке		= ДиалогВыбораФайла.ПолноеИмяФайла;
		
		//ЗагрузитьОбработку();
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьОбработку()
	ПараметрыЗащиты = Новый("ОписаниеЗащитыОтОпасныхДействий"+"");
	ПараметрыЗащиты.ПредупреждатьОбОпасныхДействиях = ЛОЖЬ;                                            
	
	//Данные = Новый ДвоичныеДанные(Объект.ПутьКОбработке);
	//АдресФайла = ПоместитьВоВременноеХранилище(Данные, УникальныйИдентификатор);
	Объект.ИспользуетсяСтандартнаяОбработка = Ложь;
	
	Обработка =  ВнешниеОбработки.Создать(ВнешниеОбработки.Подключить(АдресФайла,,Ложь, ПараметрыЗащиты), Ложь);
	Объект.НазваниеОбработки = Обработка.Метаданные().Имя;
	Если Объект.Наименование = "" Тогда	
		Объект.Наименование = Обработка.Метаданные().Синоним;
	КонецЕсли;	
КонецПроцедуры	


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка = Справочники.CRM_УсловияСрабатыванияТриггеров.ПоРасписанию Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Редактирование данного условия срабатывания триггера запрещено!'"));
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаОбработкаПуть.Видимость = Не Объект.ИспользоватьСКД;
	Элементы.РедактироватьСхемуКомпоновкиДанных.Видимость = Объект.ИспользоватьСКД;
	ОбъектЗначение = РеквизитФормыВЗначение("Объект");
	АдресФайла = ПоместитьВоВременноеХранилище(ОбъектЗначение.ОбработкаПроверки.Получить(), УникальныйИдентификатор);
	Если ОбъектЗначение.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		СформироватьСКДПоОбъекту();
	Иначе	
		АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(ОбъектЗначение.ХранилищеСхемыКомпоновкиДанных.Получить(), УникальныйИдентификатор);
		АдресНастроекКомпоновкиДанных = ПоместитьВоВременноеХранилище(ОбъектЗначение.ХранилищеНастроекКомпоновкиДанных.Получить(), УникальныйИдентификатор);
	КонецЕсли;
	
	УстановитьВидимость();
	СобытиеПриИзмененииНаСервере();
		
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ОбработкаПроверки = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресФайла));
	ТекущийОбъект.ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных));
	ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных));
КонецПроцедуры

&НаСервере
Функция ПолучитьДвоичныеДанныеИзХранилища()
	ОбъектПолучения = РеквизитФормыВЗначение("Объект");
	Возврат(ОбъектПолучения.ОбработкаПроверки.Получить());
КонецФункции


&НаКлиенте
Процедура ПодготовитьКВыгрузкеОбработкуНаСервере()
	//ОбъектЗначение = РеквизитФормыВЗначение("Объект");
	ДанныеФайла = ПолучитьДвоичныеДанныеИзХранилища();
	АдресФайла = ПоместитьВоВременноеХранилище(ДанныеФайла, УникальныйИдентификатор);
КонецПроцедуры


&НаКлиенте
Процедура ВыгрузитьОбработку(Команда)
	ПодготовитьКВыгрузкеОбработкуНаСервере();

	ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(
			Новый ОписаниеОповещения(
				"ВыгрузитьОбработкуПродолжение",
				ЭтотОбъект,
				Новый Структура),
			НСтр("ru = 'Для продолжения необходимо установить расширение для работы с файлами.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьОбработкуПродолжение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт

    ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьВыборФайла", ЭтаФорма);
	ИмяФайла = Объект.НазваниеОбработки+".epf";
	Файл = Новый ОписаниеПередаваемогоФайла(ИмяФайла, АдресФайла);
	ПолучаемыеФайлы = Новый Массив;
	ПолучаемыеФайлы.Добавить(Файл);
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогОткрытияФайла.Фильтр = "(*.epf)|*.epf";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	НачатьПолучениеФайлов(ОписаниеОповещения, ПолучаемыеФайлы, ДиалогОткрытияФайла, Истина);
    
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборФайла(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт

    Если ПомещенныеФайлы = Неопределено Тогда
        Возврат;
    КонецЕсли;

    Для каждого ПереданныйФайл Из ПомещенныеФайлы Цикл
		Объект.ПутьКОбработке		= ПереданныйФайл.Имя;
		ЭтаФорма.Модифицированность = Истина;
    КонецЦикла;
    
КонецПроцедуры



&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанных(Команда)
	
	// Открыть редактор настроек схемы компоновки данных
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = НСтр("ru = 'Настройка шаблона условий проверки ""%1""'");
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = СтрЗаменить(ЗаголовокФормыНастройкиСхемыКомпоновкиДанных, "%1", Объект.Наименование);
	ОповещениеЗакрытия = Новый ОписаниеОповещения("ПослеРедактированияСхемы", ЭтотОбъект);
	АдресаНастроек = ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных",
		Новый Структура(
						"НеПомещатьНастройкиВСхемуКомпоновкиДанных,
						|НеРедактироватьСхемуКомпоновкиДанных,
						|НеНастраиватьУсловноеОформление,
						|НеНастраиватьВыбор,
						|НеНастраиватьПорядок,
						|УникальныйИдентификатор,
						|АдресСхемыКомпоновкиДанных,
						|АдресНастроекКомпоновкиДанных,
						|Заголовок,
						//|ИсточникШаблонов,
						|ИмяШаблонаСКД,
						|ВозвращатьИмяТекущегоШаблонаСКД",
						Истина,
						Ложь,
						Истина,
						Истина,
						Истина,
						УникальныйИдентификатор,
						АдресСхемыКомпоновкиДанных,
						АдресНастроекКомпоновкиДанных,
						ЗаголовокФормыНастройкиСхемыКомпоновкиДанных,
						//,
						ЗаголовокФормыНастройкиСхемыКомпоновкиДанных,
						Истина), ЭтотОбъект,,,,ОповещениеЗакрытия);
	
	
	
	//УстановитьДоступностьИВидимостьЭлементовФормы(Объект, Элементы, РазмерностьДоступна());
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеРедактированияСхемы(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
				
		Если РезультатЗакрытия.Свойство("АдресХранилищаНастройкиКомпоновщика") Тогда
			АдресНастроекКомпоновкиДанных = РезультатЗакрытия.АдресХранилищаНастройкиКомпоновщика;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры	

&НаСервере
Процедура СформироватьСКДПоОбъекту()
	СКДПроверка = Новый СхемаКомпоновкиДанных();
	
	ИсточникДанных = СКДПроверка.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанныхПроверка";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СКДПроверка.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанныхПроверка";
	НаборДанных.ИсточникДанных = "ИсточникДанныхПроверка";
	
	НаборДанных.Запрос = ПолучитьТекстЗапросаПоОбъекту();
	
	НастройкиСКД = 	СКДПроверка.НастройкиПоУмолчанию;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКДПроверка));
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиСКД);
		
	АдресНастроекКомпоновкиДанных = ПоместитьВоВременноеХранилище(НастройкиСКД, УникальныйИдентификатор);
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКДПроверка, УникальныйИдентификатор);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКДПроверка));
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиСКД);
	КомпоновщикНастроек.Восстановить();
КонецПроцедуры	

&НаСервере
Функция ПолучитьТекстЗапросаПоОбъекту()
	Если Объект.ОбъектОбработки = "" Тогда
		Возврат "ВЫБРАТЬ
		|	ИСТИНА КАК Ссылка";
	КонецЕсли;	
	ТекстЗапроса = "ВЫБРАТЬ Разрешенные
	|	"+Объект.ОбъектОбработки+".Ссылка";
	Если Объект.ТипОбъекта = "Документ" Тогда
		Для Каждого РеквизитОбъекта Из Метаданные.Документы[Объект.ОбъектОбработки].СтандартныеРеквизиты Цикл
			Если РеквизитОбъекта.Имя = "Ссылка" Тогда Продолжить конецЕсли;
			ТекстЗапроса = ТекстЗапроса + ",
			|"+Объект.ОбъектОбработки+"."+РеквизитОбъекта.Имя;
		КонецЦикла;
		Для Каждого РеквизитОбъекта Из Метаданные.Документы[Объект.ОбъектОбработки].Реквизиты Цикл
			ТекстЗапроса = ТекстЗапроса + ",
			|"+Объект.ОбъектОбработки+"."+РеквизитОбъекта.Имя;
		КонецЦикла;	
		
		ТекстЗапроса = ТекстЗапроса + "
		| ИЗ Документ."+Объект.ОбъектОбработки+" КАК "+Объект.ОбъектОбработки+"
		|ГДЕ
		|	"+Объект.ОбъектОбработки+".Ссылка = &Ссылка";
	ИначеЕсли Объект.ТипОбъекта = "Справочник" Тогда
		Для Каждого РеквизитОбъекта Из Метаданные.Справочники[Объект.ОбъектОбработки].СтандартныеРеквизиты Цикл
			Если РеквизитОбъекта.Имя = "Ссылка" Тогда Продолжить конецЕсли;
			ТекстЗапроса = ТекстЗапроса + ",
			|"+Объект.ОбъектОбработки+"."+РеквизитОбъекта.Имя;
		КонецЦикла;
		Для Каждого РеквизитОбъекта Из Метаданные.Справочники[Объект.ОбъектОбработки].Реквизиты Цикл
			ТекстЗапроса = ТекстЗапроса + ",
			|"+Объект.ОбъектОбработки+"."+РеквизитОбъекта.Имя;
		КонецЦикла;	
		
		ТекстЗапроса = ТекстЗапроса + "
		| ИЗ Справочник."+Объект.ОбъектОбработки+" КАК "+Объект.ОбъектОбработки+"
		|ГДЕ
		|	"+Объект.ОбъектОбработки+".Ссылка = &Ссылка";
	ИначеЕсли Объект.ТипОбъекта = "Бизнес-процесс" Тогда
		Для Каждого РеквизитОбъекта Из Метаданные.БизнесПроцессы[Объект.ОбъектОбработки].СтандартныеРеквизиты Цикл
			Если РеквизитОбъекта.Имя = "Ссылка" Тогда Продолжить конецЕсли;
			ТекстЗапроса = ТекстЗапроса + ",
			|"+Объект.ОбъектОбработки+"."+РеквизитОбъекта.Имя;
		КонецЦикла;
		Для Каждого РеквизитОбъекта Из Метаданные.БизнесПроцессы[Объект.ОбъектОбработки].Реквизиты Цикл
			ТекстЗапроса = ТекстЗапроса + ",
			|"+Объект.ОбъектОбработки+"."+РеквизитОбъекта.Имя;
		КонецЦикла;	
		
		ТекстЗапроса = ТекстЗапроса + "
		| ИЗ БизнесПроцесс."+Объект.ОбъектОбработки+" КАК "+Объект.ОбъектОбработки+"
		|ГДЕ
		|	"+Объект.ОбъектОбработки+".Ссылка = &Ссылка";
	ИначеЕсли Объект.ТипОбъекта = "Задача" Тогда
		Для Каждого РеквизитОбъекта Из Метаданные.Задачи[Объект.ОбъектОбработки].СтандартныеРеквизиты Цикл
			Если РеквизитОбъекта.Имя = "Ссылка" Тогда Продолжить конецЕсли;
			ТекстЗапроса = ТекстЗапроса + ",
			|"+Объект.ОбъектОбработки+"."+РеквизитОбъекта.Имя;
		КонецЦикла;
		Для Каждого РеквизитОбъекта Из Метаданные.Задачи[Объект.ОбъектОбработки].Реквизиты Цикл
			ТекстЗапроса = ТекстЗапроса + ",
			|"+Объект.ОбъектОбработки+"."+РеквизитОбъекта.Имя;
		КонецЦикла;	
		
		ТекстЗапроса = ТекстЗапроса + "
		| ИЗ Задача."+Объект.ОбъектОбработки+" КАК "+Объект.ОбъектОбработки+"
		|ГДЕ
		|	"+Объект.ОбъектОбработки+".Ссылка = &Ссылка";
	

	КонецЕсли;
	Возврат ТекстЗапроса;
КонецФункции	

&НаКлиенте
Процедура ИспользоватьСКДПриИзменении(Элемент)
	
	Элементы.ГруппаОбработкаПуть.Видимость = Не Объект.ИспользоватьСКД;
	Элементы.РедактироватьСхемуКомпоновкиДанных.Видимость = Объект.ИспользоватьСКД;
	Элементы.НазваниеОбработки.Видимость = НЕ Объект.ИспользоватьСКД;

КонецПроцедуры

&НаСервере
Процедура СобытиеПриИзмененииНаСервере()
	
	Если Объект.Событие = Перечисления.CRM_СобытияТриггеров.ВыполнитьПереопределяемуюКоманду
	ИЛИ Объект.Событие = Перечисления.CRM_СобытияТриггеров.ОбработкаОповещения
	ИЛИ Объект.Событие = Перечисления.CRM_СобытияТриггеров.ПередЗаписьюНаСервере
	ИЛИ Объект.Событие = Перечисления.CRM_СобытияТриггеров.ПослеЗаписиНаСервере
	ИЛИ Объект.Событие = Перечисления.CRM_СобытияТриггеров.ПриСозданииНаСервере Тогда
		
		Объект.ИспользоватьСКД									= Истина;
		Объект.РежимОтладки										= Ложь;
		Элементы.ИспользоватьСКД.Видимость						= Ложь;
		Элементы.ГруппаОбработкаПуть.Видимость					= Ложь;
		Элементы.НазваниеОбработки.Видимость					= Ложь;
		Элементы.РедактироватьСхемуКомпоновкиДанных.Видимость	= Ложь;
	Иначе
		Элементы.ИспользоватьСКД.Видимость						= Истина;
		Элементы.РедактироватьСхемуКомпоновкиДанных.Видимость	= Истина;
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СобытиеПриИзменении(Элемент)
	Объект.Наименование = Объект.ТипОбъекта+"("+Объект.ОбъектОбработкиПредставление+")"+" - "+Объект.Событие;
	
	СобытиеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	СписокОбъектов = ПолучитьСписокОбъектовДляОбработки();
	Объект.ОбъектОбработки = СписокОбъектов[0].Значение;
	Объект.ОбъектОбработкиПредставление = СписокОбъектов[0].Представление;
	СформироватьСКДПоОбъекту();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбработку1(Команда)
	
	ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(
			Новый ОписаниеОповещения(
				"ЗагрузитьОбработкуПродолжение",
				ЭтотОбъект,
				Новый Структура),
			НСтр("ru = 'Для продолжения необходимо установить расширение для работы с файлами.'"));

КонецПроцедуры
	
&НаКлиенте
Процедура ЗагрузитьОбработкуПродолжение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт

	ОписаниеОповещенияЗавершения = Новый ОписаниеОповещения("ВопросЗагрузитьОбработку", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещенияЗавершения, "Вы хотите загрузить новую обработку действия ?", РежимДиалогаВопрос.ДаНет);
    
КонецПроцедуры


&НаКлиенте
Процедура ВопросЗагрузитьОбработку(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьОбработкуЗавершение", ЭтаФорма);
		ИмяФайла = Объект.НазваниеОбработки+".epf";
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.Фильтр = "(*.epf)|*.epf";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		НачатьПомещениеФайлов(ОписаниеОповещения, , ДиалогОткрытияФайла, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбработкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		АдресФайла = Результат[0].Хранение;
		Объект.ПутьКОбработке = Результат[0].Имя;
		ЗагрузитьОбработку();
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РежимОтладкиПриИзменении(Элемент)
	Если НЕ Объект.РежимОтладки И НЕ Объект.ИспользоватьСКД Тогда
		ОписаниеОповещенияЗавершения = Новый ОписаниеОповещения("ВопросЗагрузитьОбработку", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияЗавершения, "Вы хотите загрузить новую обработку действия ?", РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли НЕ Объект.ИспользоватьСКД Тогда
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		
		ДиалогВыбораФайла.Фильтр = "Файл обработки (*.epf)|*.epf";
		ДиалогВыбораФайла.Расширение = "html";
		
		ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Выберите файл'");
		ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
		ДиалогВыбораФайла.ИндексФильтра = 0;
		ДиалогВыбораФайла.ПолноеИмяФайла = Объект.ПутьКОбработке;
		ДиалогВыбораФайла.ПроверятьСуществованиеФайла = истина;
		
		Если ДиалогВыбораФайла.Выбрать() Тогда
			
			Объект.ПутьКОбработке		= ДиалогВыбораФайла.ПолноеИмяФайла;
			
			//ЗагрузитьОбработку();
			ЭтаФорма.Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;	    
	УстановитьВидимость();

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСтандартнуюОбработкуНаСервере()
	
	Если Объект.ИмяПредопределенныхДанных = "ПроверкаСвязиСИнтересом" Тогда	
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_УсловияСрабатыванияТриггеров.ПолучитьМакет("ПроверкаСвязиСИнтересом"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "ПроверкаСвязиСИнтересом";
	ИначеЕсли Объект.ИмяПредопределенныхДанных = "ПисьмоОтНовогоКлиента" Тогда	
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_УсловияСрабатыванияТриггеров.ПолучитьМакет("ПисьмоОтНовогоКлиента"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "ПисьмоОтНовогоКлиента";	
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура ЗагрузитьСтандартнуюОбработку(Команда)
	ЗагрузитьСтандартнуюОбработкуНаСервере();
	ЭтаФорма.Модифицированность = Истина;
	Объект.ИспользуетсяСтандартнаяОбработка = Истина;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ВебКлиент Тогда
		Элементы.РежимОтладки.Видимость = Ложь;
	#КонецЕсли
КонецПроцедуры

