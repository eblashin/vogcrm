
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Подсистема запрета редактирования ключевых реквизитов объектов.
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
	ЕстьПравоИзменения =  ПравоДоступа("Изменение",Метаданные.Справочники.СегментыНоменклатуры);
	
	СегментыСервер.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СегментыСервер.ПередЗаписьюНаСервере(ЭтотОбъект,ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	 УправлениеДоступностью();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов.
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособФормированияПриИзменении(Элемент)

	Если Объект.СпособФормирования <>
		ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ФормироватьВручную") Тогда
		Элементы.ДатаОчистки.ТолькоПросмотр = Истина;
		Объект.ДатаОчистки = '00010101';
	Иначе
		Элементы.ДатаОчистки.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
	УправлениеДоступностью();

КонецПроцедуры

&НаКлиенте
Процедура СпособФормированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//Если НЕ Объект.Ссылка.Пустая() Тогда
	//	
	//	Ответ = Вопрос(НСтр("ru = 'Текущий состав сегмента будет очищен. Продолжить?'"), РежимДиалогаВопрос.ОКОтмена);
	//	
	//	Если Ответ = КодВозвратаДиалога.ОК Тогда
	//		СегментыСервер.Очистить(Объект.Ссылка);
	//	Иначе
	//		СтандартнаяОбработка = Ложь;
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Сначала необходимо записать сегмент.'"));
		Возврат;
	КонецЕсли;

	Если Объект.СпособФормирования =
			ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ФормироватьДинамически") Тогда
		ПоказатьПредупреждение(, НСтр("ru='Формирование доступно только для нединамических сегментов.'"));
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СформироватьЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения,
				НСтр("ru='Перед формированием необходимо записать сегмент. Записать?'"),
				РежимДиалогаВопрос.ДаНет);
		
	Иначе
		СформироватьЗавершение(Неопределено, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Записать();
	КонецЕсли;

	СегментыСервер.Сформировать(Объект.Ссылка);
	ПоказатьОповещениеПользователя(
		НСтр("ru='Формирование сегмента номенклатуры'"),,
		НСтр("ru='Сегмент сформирован.'")
	);

КонецПроцедуры

&НаКлиенте
Процедура МаркетинговыеМероприятия(Команда)

	ОткрытьФорму("Справочник.МаркетинговыеМероприятия.ФормаСписка",
		Новый Структура("Отбор",Новый Структура("СегментНоменклатуры",Объект.Ссылка)),
		ЭтотОбъект,
		КлючУникальности,
		Окно
	);

КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)

	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = НСтр("ru = 'Настройки сегмента ""%ИмяСегмента%""'");
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = СтрЗаменить(ЗаголовокФормыНастройкиСхемыКомпоновкиДанных, "%ИмяСегмента%", Объект.Наименование);
	
	Адреса = СегментыСервер.ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище(
		Объект.Ссылка,
		Объект.ИмяШаблонаСКД,
		АдресСКД, 
		АдресНастроекСКД,
		УникальныйИдентификатор);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкиЗавершение", ЭтотОбъект, Адреса);
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных",
		Новый Структура(
			"АдресСхемыКомпоновкиДанных,
			|АдресНастроекКомпоновкиДанных,
			|ИсточникШаблонов,
			|Заголовок,
			|НеПомещатьНастройкиВСхемуКомпоновкиДанных,
			|НеНастраиватьУсловноеОформление,
			|НеНастраиватьПорядок,
			|НеНастраиватьВыбор,
			|УникальныйИдентификатор,
			|ИмяШаблонаСКД,
			|ВозвращатьИмяТекущегоШаблонаСКД",
			Адреса.СхемаКомпоновкиДанных,
			Адреса.НастройкиКомпоновкиДанных,
			Объект.Ссылка,
			ЗаголовокФормыНастройкиСхемыКомпоновкиДанных,
			Истина,
			Истина,
			Истина,
			Истина,
			УникальныйИдентификатор,
			Объект.ИмяШаблонаСКД,
			Истина),
			,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗавершение(Результат, Адреса) Экспорт

	Если Результат <> Неопределено Тогда
			
		Объект.ИмяШаблонаСКД = Результат.ИмяТекущегоШаблонаСКД;
			
		Изменения = СегментыСервер.ПрименитьИзмененияКСхемеКомпоновкиДанных(
			Объект.Ссылка,
			Объект.ИмяШаблонаСКД, 
			Адреса.СхемаКомпоновкиДанных,
			Результат.АдресХранилищаНастройкиКомпоновщика,
			УникальныйИдентификатор);
		
		Объект.ИмяШаблонаСКД = Изменения.ИмяШаблонаСКД;
		ПредставлениеШаблонаСКД = Изменения.ПредставлениеШаблонаСКД;
		АдресСКД = Изменения.АдресСКД;
		АдресНастроекСКД = Изменения.АдресНастроекСКД;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Модифицированность = Истина;
		Расписание         = Результат;
		РасписаниеСтрокой  = Строка(Расписание);
		
	КонецЕсли;
	
КонецПроцедуры

// Команда подсистемы "Запрет редактирования реквизитов"
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		
		Результат = Неопределено;

		
		ОткрытьФорму("Справочник.СегментыНоменклатуры.Форма.РазблокированиеРеквизитов",,,,,, Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Результат);
        
    КонецЕсли;

КонецПроцедуры 



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеДоступностью()
	
	Элементы.СтраницаРасписание.Доступность =
		(Объект.СпособФормирования = ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ПериодическиОбновлять"));
	
КонецПроцедуры

#КонецОбласти
