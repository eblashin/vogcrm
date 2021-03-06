&НаКлиенте
Перем ОтказТемп;

&НаКлиенте
Перем ТипДоговора;

&НаКлиенте
Перем ФормаДоговора;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ПолучитьИсходноеСодержаниеПункта(ПунктДоговора);
	Возврат ПунктДоговора.Содержание;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТипДоговора(ДоговорКонтрагента)
	Возврат ДоговорКонтрагента.вогТипДоговора;	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьФормуДоговора(ДоговорКонтрагента)
	Возврат ДоговорКонтрагента.вогФормаДоговора;	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНомерСтрокиВарианта(Форма)
	СтруктураПоиска = Новый Структура("ИДВарианта", Форма.ИДВарианта);
	НайденныеСтроки = Форма.Объект.Пункты.НайтиСтроки(СтруктураПоиска);
	Счетчик = 1;
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		НайденнаяСтрока.НомерСтрокиВарианта = Счетчик;
		Счетчик = Счетчик + 1;
	КонецЦикла;
КонецПроцедуры



#Область ПроцедурыДействияКомандныхПанелейФормы

&НаКлиенте
Процедура ПунктыСдвинутьВверх(Команда)
	Попытка
		ИндексТекСтроки = Объект.Пункты.Индекс(Элементы.Пункты.ТекущиеДанные);
		Объект.Пункты.Сдвинуть(ИндексТекСтроки, -1);
		Элементы.Пункты.ОтборСтрок = Новый ФиксированнаяСтруктура("ИДВарианта", ИДВарианта);
		Модифицированность = Истина;
		
		ЗаполнитьНомерСтрокиВарианта(ЭтотОбъект);
	Исключение 
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПунктыСдвинутьВниз(Команда)
	Попытка
		ИндексТекСтроки = Объект.Пункты.Индекс(Элементы.Пункты.ТекущиеДанные);
		Объект.Пункты.Сдвинуть(ИндексТекСтроки, 1);
		Элементы.Пункты.ОтборСтрок = Новый ФиксированнаяСтруктура("ИДВарианта", ИДВарианта);
		Модифицированность = Истина;
		
		ЗаполнитьНомерСтрокиВарианта(ЭтотОбъект);
	Исключение 
	КонецПопытки;

КонецПроцедуры

#КонецОбласти 


#Область ПроцедурыОбработчикиСобытийРеквизитовТабличнойЧасти

&НаКлиенте
Процедура ПунктыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПунктыПередНачаломДобавленияЗавершение", ЭтотОбъект, Копирование);
	РазрешеноИзменениеПунктов(Новый Структура("ПунктыТекущаяСтрока", Элемент.ТекущиеДанные), ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПунктыПередНачаломДобавленияЗавершение(РазрешеноИзменениеПунктов, Копирование) Экспорт
	
	Если НЕ РазрешеноИзменениеПунктов Тогда
		Возврат;
	КонецЕсли;
	
	ТекСтрока = Элементы.Пункты.ТекущиеДанные;
	
	НоваяСтрока = Объект.Пункты.Добавить();
	НоваяСтрока.ИДВарианта = ИДВарианта;
	НоваяСтрока.ИмяВарианта = ИмяВариантаДляТабличнойЧасти(ИДВарианта);
	
	Если Копирование И ТекСтрока <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока,, "НомерСтроки,НомерСтрокиВарианта");
	КонецЕсли;
	
	ЗаполнитьНомерСтрокиВарианта(ЭтотОбъект);
	
	Элементы.Пункты.ОтборСтрок = Новый ФиксированнаяСтруктура("ИДВарианта", ИДВарианта);
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПунктыПередНачаломИзменения(Элемент, Отказ)
	ОтказТемп = Истина;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПунктыПередНачаломИзмененияЗавершение", ЭтотОбъект);
	РазрешеноИзменениеПунктов(Новый Структура("ПунктыТекущаяСтрока", Элемент.ТекущиеДанные), ОписаниеОповещения);
	Отказ = ОтказТемп;
КонецПроцедуры

&НаКлиенте
Процедура ПунктыПередНачаломИзмененияЗавершение(РазрешеноИзменениеПунктов, ДополнительныеПараметры) Экспорт

	ОтказТемп = НЕ РазрешеноИзменениеПунктов;
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктыПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПунктыПередУдалениемЗавершение", ЭтотОбъект);
	РазрешеноИзменениеПунктов(Новый Структура("ПунктыТекущаяСтрока", Элемент.ТекущиеДанные), ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПунктыПередУдалениемЗавершение(РазрешеноИзменениеПунктов, ДополнительныеПараметры) Экспорт
	
	Если РазрешеноИзменениеПунктов Тогда
		Объект.Пункты.Удалить(Объект.Пункты.Индекс(Элементы.Пункты.ТекущиеДанные));
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Элемент.ТекущиеДанные.ИДВарианта  = ИДВарианта;
	Элемент.ТекущиеДанные.ИмяВарианта = ИмяВариантаДляТабличнойЧасти(ИДВарианта);
	
	Если ФормаДоговора = ПредопределенноеЗначение("Перечисление.вогТипыФормДоговоров.ФормаКлиента") Тогда
		КС = Новый КвалификаторыСтроки(25);
		Массив = Новый Массив;
		Массив.Добавить(Тип("Строка"));
		Элементы.ПунктыПунктДоговора.ОграничениеТипа = Новый ОписаниеТипов(Массив, , КС);
	Иначе
		Элементы.ПунктыПунктДоговора.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.вогПунктыДоговоровКонтрагентов");
	КонецЕсли;

КонецПроцедуры



&НаКлиенте
Процедура ПунктыПунктДоговораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ФормаДоговора = ПредопределенноеЗначение("Перечисление.вогТипыФормДоговоров.ФормаКлиента") Тогда
		КС = Новый КвалификаторыСтроки(25);
		Массив = Новый Массив;
		Массив.Добавить(Тип("Строка"));
		Элемент.ОграничениеТипа = Новый ОписаниеТипов(Массив, , КС);
	Иначе
		Элемент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.вогПунктыДоговоровКонтрагентов");
	
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", ТипДоговора));
		
		ФормаВыбора = ПолучитьФорму("Справочник.вогПунктыДоговоровКонтрагентов.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
		ФормаВыбора.Открыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПунктыПунктДоговораПриИзменении(Элемент)
	ТекСтрока = Элементы.Пункты.ТекущиеДанные;
	Если ФормаДоговора = ПредопределенноеЗначение("Перечисление.вогТипыФормДоговоров.ФормаКлиента") Тогда
		ТекСтрока.ИсходныйВариант = "";		
	Иначе
		ТекСтрока.ИсходныйВариант = ПолучитьИсходноеСодержаниеПункта(ТекСтрока.ПунктДоговора); 		
	КонецЕсли; 
КонецПроцедуры




#КонецОбласти 


#Область ПроцедурыДляРаботыСВариантами

&НаКлиенте
Процедура ПанельВариантовВыбратьВариант(Команда, ЗаписыватьКомментарийВарианта = Неопределено)
	
	ИмяКоманды = Команда.Имя;
	ИмяКнопки = "Вариант" + СтрЗаменить(ИмяКоманды, "КомандаВариант", "");
	Кнопка = Элементы[ИмяКнопки];
	
	Если Кнопка.Пометка Тогда
		
		// Запустим механизм переименования кнопки.
		КомандаПереименоватьВариант(Команда);
		
	Иначе
		
		// Запустим механизм переключения варианта.
		ЗаписыватьКомментарий = ?(ЗаписыватьКомментарийВарианта = Неопределено, Истина, ЗаписыватьКомментарийВарианта);
	
		Если ЗаписыватьКомментарий Тогда
			
			// Запишем содержимое комментария варианта.
			ЗаписатьКомментарийВарианта(ИДВарианта);
		
		КонецЕсли;
		
		// Получим идентификатор выбранного варианта.
		ИДВарианта = ПолучитьИдентификаторВарианта(Кнопка);
		
		// Установим отбор номенклатуры по выбранному варианту.
		Элементы.Пункты.ОтборСтрок = Новый ФиксированнаяСтруктура("ИДВарианта", ИДВарианта);
		
		МассивСтрокВариантов = Объект.Пункты.НайтиСтроки(Новый Структура("ИДВарианта", ИДВарианта));
		
		Если МассивСтрокВариантов.Количество() = 0 Тогда
			Элементы.КнопкаУтвердитьВариант.Пометка = Ложь;
		Иначе
			Элементы.КнопкаУтвердитьВариант.Пометка = Найти(Кнопка.Заголовок, НСтр("ru = '(Утв.)'"));
		КонецЕсли;
		
		// Установим пометку у выбранного варианта.
		Для каждого КнопкаПанелиВариантов Из Элементы.КоманднаяПанельВариантов.ПодчиненныеЭлементы Цикл
			КнопкаПанелиВариантов.Пометка = Ложь;
		КонецЦикла;
		
		Кнопка.Пометка = Истина;
		
		// Установим комментарий выбранного варианта.
		УстановитьКомментарийВарианта(ИДварианта);
		
		СписокЗагруженПриСменеВарианта = Истина;
		
	КонецЕсли;
	
	ЗаполнитьНомерСтрокиВарианта(ЭтотОбъект);
КонецПроцедуры

// Устанавливает значение комментария из табличной части в поле ввода.
//
// Параметры:
//  НомерВарианта – Число – номер варианта.
//
&НаКлиенте
Процедура УстановитьКомментарийВарианта(НомерВарианта)
	
	СтрокиКомментариев = ТаблицаКомментариевВариантов.НайтиСтроки(Новый Структура("ИДВарианта",НомерВарианта));
	
	Если СтрокиКомментариев.Количество() = 0 Тогда
		КомментарийВарианта =  "";
	Иначе
		КомментарийВарианта = СтрокиКомментариев[0].КомментарийВарианта;
	КонецЕсли;

КонецПроцедуры // УстановитьКомментарийВарианта()

// записывает значение комментария из поля ввода в табличную часть.
//
// Параметры:
//  НомерВарианта – Число – номер варианта.
//
&НаКлиенте
Процедура ЗаписатьКомментарийВарианта(НомерВарианта)
	
	СтрокиКомментариев = ТаблицаКомментариевВариантов.НайтиСтроки(Новый Структура("ИДВарианта",НомерВарианта));
	
	Если СтрокиКомментариев.Количество() = 0 Тогда
		СтрокаКомментария = ТаблицаКомментариевВариантов.Добавить();
		СтрокаКомментария.ИДВарианта = НомерВарианта;
	Иначе
		СтрокаКомментария = СтрокиКомментариев[0];
	КонецЕсли;
	
	СтрокаКомментария.КомментарийВарианта = КомментарийВарианта;

КонецПроцедуры // ЗаписатьКомментарийВарианта()

// Возвращает номер Варианта
//
// Параметры:
//	Кнопка формф
//	Если кнопка указана, возвращается номер, иначе генерируется новый.
// Возвращаемое значение:
//   Число   
//
&НаКлиенте
Функция ПолучитьИдентификаторВарианта(Кнопка = Неопределено)
	
	Если Кнопка = Неопределено Тогда
		
		// Найдем идентификатор нового варианта.
		СписокНомеров = СписокИменВариантов.Скопировать();
		СписокНомеров.СортироватьПоЗначению(НаправлениеСортировки.Возр);

		НовыйИдентификатор = СписокНомеров[СписокНомеров.Количество()-1].Значение + 1;
		
		Возврат НовыйИдентификатор;
		
	Иначе
		
		// Найдем идентификатор варианта нажатой кнопки.
		ИндексКнопки = Элементы.КоманднаяПанельВариантов.ПодчиненныеЭлементы.Индекс(Кнопка);
		Возврат СписокИменВариантов[ИндексКнопки].Значение;
		
	КонецЕсли;
КонецФункции // ПолучитьИдентификаторВарианта()

// Удаление элемента формы
//
&НаСервере
Процедура УдалитьКнопкуВарианта(ИмяУдаляемогоЭлемента)
	
	// удалим элемент (кнопку)
	УдаляемыйЭлемент = Элементы[ИмяУдаляемогоЭлемента];
	Элементы.Удалить(УдаляемыйЭлемент);
	
	// удалим команду кнопки
	УдаляемаяКоманда = Команды["Команда" + ИмяУдаляемогоЭлемента];
	Команды.Удалить(УдаляемаяКоманда);

КонецПроцедуры

&НаКлиенте
Процедура КомандаУдалитьВариант(Команда)
	КнопкиВариантов = Элементы.КоманднаяПанельВариантов.ПодчиненныеЭлементы;

	Если КнопкиВариантов.Количество() = 2 Тогда // Один вариант + кнопка добавления.
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя удалить единственный вариант!'"));
		Возврат;
	КонецЕсли;
	
	// Запросим подтверждение удаления варианта.
	ТекстВопроса = НСтр("ru = 'Удалить вариант?'");
	Если Элементы.КнопкаУтвердитьВариант.Пометка Тогда
		ТекстВопроса = НСтр("ru = 'Данный вариант утвержден!
					   |'") + ТекстВопроса; 
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаУдалитьВариантЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура КомандаУдалитьВариантЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	КнопкиВариантов = Элементы.КоманднаяПанельВариантов.ПодчиненныеЭлементы;
	УдаляемаяКнопка = Элементы["Вариант" + ИдВарианта];
	ИндексУдаляемойКнопки = КнопкиВариантов.Индекс(УдаляемаяКнопка);
	
	// Удалим имя кнопки из списка имен;
	СписокИменВариантов.Удалить(ИндексУдаляемойКнопки);
	
	// Удалим номенклатуру варианта.
	СтрокиПунктов = Объект.Пункты.НайтиСтроки(Новый Структура("ИДВарианта", ИДВарианта));
	Для каждого СтрокаПунктов Из СтрокиПунктов Цикл
		Объект.Пункты.Удалить(СтрокаПунктов);
	КонецЦикла;
	
	// удалим кнопку варианта
	УдалитьКнопкуВарианта("Вариант" + ИдВарианта);
	
	// Удалим комментарий варианта.
	МассивСтрокТаблицыКомментариев = ТаблицаКомментариевВариантов.НайтиСтроки(Новый Структура("ИДВарианта", ИДВарианта));
	
	Если МассивСтрокТаблицыКомментариев.Количество() > 0 Тогда
		
		СтрокаТаблицыКомментариев = МассивСтрокТаблицыКомментариев[0];
		ТаблицаКомментариевВариантов.Удалить(ТаблицаКомментариевВариантов.Индекс(СтрокаТаблицыКомментариев));
	
	КонецЕсли;
	
	МассивСтрокТаблицыКомментариев = Объект.КомментарииВариантов.НайтиСтроки(Новый Структура("ИДВарианта", ИДВарианта));
	
	Если МассивСтрокТаблицыКомментариев.Количество() > 0 Тогда
		
		СтрокаТаблицыКомментариев = МассивСтрокТаблицыКомментариев[0];
		Объект.КомментарииВариантов.Удалить(СтрокаТаблицыКомментариев);
	
	КонецЕсли;
	
	Если КнопкиВариантов.Количество() = 2 Тогда // Остался один вариант + кнопка добавления
		// сделаем активным единственный оставшийся вариант.
		КнопкаТекущегоВарианта = КнопкиВариантов[0];
	
	ИначеЕсли КнопкиВариантов.Количество() = ИндексУдаляемойКнопки + 1 Тогда // Посл. справа кнопка варианта.
		
		// Сделаем активным предыдущий вариант.
		КнопкаТекущегоВарианта = КнопкиВариантов[ИндексУдаляемойКнопки - 1];
		
	Иначе
		
		// Сделаем активным следующий вариант.
		КнопкаТекущегоВарианта = КнопкиВариантов[ИндексУдаляемойКнопки];
		
	КонецЕсли;
	
	ПанельВариантовВыбратьВариант(Команды["Команда" + КнопкаТекущегоВарианта.Имя], Ложь);

КонецПроцедуры

&НаКлиенте
Процедура КомандаСкопироватьВариант(Команда)
	СтрокиПунктов = Объект.Пункты.НайтиСтроки(Новый Структура("ИДВарианта", ИДВарианта));
	
	НовыйНомерВарианта = ПолучитьИдентификаторВарианта();
	СписокИменВариантов.Добавить(НовыйНомерВарианта, "Вариант "+НовыйНомерВарианта);
	
	Для каждого СтрокаПунктов Из СтрокиПунктов Цикл
		НоваяСтрока = Объект.Пункты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПунктов);
		НоваяСтрока.ИДВарианта = НовыйНомерВарианта;
		НоваяСтрока.ИмяВарианта = "";
		НоваяСтрока.Утвержден = Ложь;
		
	КонецЦикла;
	
	// Скопируем комментарий варианта.
	
	СтрокаКомментарияНовогоВарианта = ТаблицаКомментариевВариантов.Добавить();
	СтрокаКомментарияНовогоВарианта.ИДВарианта = НовыйНомерВарианта;
	СтрокаКомментарияНовогоВарианта.КомментарийВарианта = КомментарийВарианта;
	
	// Добавим кнопку нового варианта на панель вариантов.
	СоздатьКнопкуВарианта(НовыйНомерВарианта, СтрЗаменить(НСтр("ru = 'Вариант %Номер%'"), "%Номер%", НовыйНомерВарианта));
	ПанельВариантовВыбратьВариант(Команды["КомандаВариант" + НовыйНомерВарианта]);

КонецПроцедуры

&НаКлиенте
Процедура КомандаПереименоватьВариант(Команда)
	
	ЭлементСпискаИменВариантов = СписокИменВариантов.НайтиПоЗначению(ИДВарианта);
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаПереименоватьВариантЗавершение", ЭтотОбъект, ЭлементСпискаИменВариантов);
	ПоказатьВводСтроки(ОписаниеОповещения, ЭлементСпискаИменВариантов.Представление, НСтр("ru = 'Введите новое имя варианта'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПереименоватьВариантЗавершение(ИмяВарианта, ЭлементСпискаИменВариантов) Экспорт
	
	Если ИмяВарианта <> Неопределено Тогда
		
		ИмяВарианта = СокрЛП(ИмяВарианта);
		ИмяВарианта= ?(ИмяВарианта = "", "Вариант " + ИДВарианта, ИмяВарианта);
		СтароеИмяВарианта = ЭлементСпискаИменВариантов.Представление;
		ВариантУтвержден = Элементы.КнопкаУтвердитьВариант.Пометка;
		
		Если НЕ ИмяВарианта = СтароеИмяВарианта Тогда
			ЭлементСпискаИменВариантов.Представление = ИмяВарианта;
			
			СтрокиВариантов = Объект.Пункты.НайтиСтроки(Новый Структура("ИДВарианта", ИДВарианта));
			
			Для каждого СтрокаВарианта Из СтрокиВариантов Цикл
				СтрокаВарианта.ИмяВарианта = ИмяВариантаДляТабличнойЧасти(ИДВарианта);
			КонецЦикла;
			
			Элементы["Вариант" + ИДВарианта].Заголовок = ?(ВариантУтвержден, ИмяВарианта + НСтр("ru = ' (Утв.)'"), ИмяВарианта);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУтвердитьВариант(Команда)
	
	МассивСтрокВариантов = Объект.Пункты.НайтиСтроки(Новый Структура("ИДВарианта", ИДВарианта));
	Если МассивСтрокВариантов.Количество() = 0 Тогда
		Элементы.КнопкаУтвердитьВариант.Пометка = Ложь;
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя утвердить вариант с незаполненной табличной частью!'"));
		Возврат;
	КонецЕсли;
	
	
	Элементы.КнопкаУтвердитьВариант.Пометка = НЕ Элементы.КнопкаУтвердитьВариант.Пометка;
	
	// по любому очищаем старую
	Для каждого КнопкаПанелиВариантов Из Элементы.КоманднаяПанельВариантов.ПодчиненныеЭлементы Цикл
		КнопкаПанелиВариантов.Заголовок = СтрЗаменить(КнопкаПанелиВариантов.Заголовок, НСтр("ru = ' (Утв.)'"), "");
	КонецЦикла;

	УтвержденныеСтроки = Объект.Пункты.НайтиСтроки(Новый Структура("Утвержден", Истина));
	Для Каждого Строка Из УтвержденныеСтроки Цикл
		Строка.Утвержден = Ложь;
	КонецЦикла;

	// Если пометка, тогда утверждаем.
	Если Элементы.КнопкаУтвердитьВариант.Пометка Тогда
		УтвердитьВариант(ИдВарианта);
		КнопкаУтверждаемогоВарианта = Элементы["Вариант" + ИдВарианта];
		КнопкаУтверждаемогоВарианта.Заголовок = КнопкаУтверждаемогоВарианта.Заголовок + НСтр("ru = ' (Утв.)'");
	КонецЕсли;
	

КонецПроцедуры

// Процедура предназначена для утверждения варианта.
//
&НаКлиенте
Процедура УтвердитьВариант(ИдентификаторВарианта = 0) Экспорт
	//
	УтвержденныеСтроки = Объект.Пункты.НайтиСтроки(Новый Структура("Утвержден", Истина));
	Для Каждого Строка Из УтвержденныеСтроки Цикл
		Строка.Утвержден = Ложь;
	КонецЦикла;
	
	СтрокиКУтверждению = Объект.Пункты.НайтиСтроки(Новый Структура("ИДВарианта", ИдентификаторВарианта));
	Для Каждого Строка Из СтрокиКУтверждению Цикл
		Строка.Утвержден = Истина;
	КонецЦикла;
	
КонецПроцедуры  // УтвердитьВариант()

// Возвращает имя вараинта по номеру.
//
// Параметры:
//  НомерВарианта - Число - номер варианта;
//
// Возвращаемое значение:
//  Строка - Имя варианта.
//	
&НаСервере
Функция ПолучитьИмяВариантаПоНомеру(НомерВарианта) Экспорт
	
	ИмяВарианта = "";
	МассивСтрокВарианта = Объект.Пункты.НайтиСтроки(Новый Структура("ИДВарианта", НомерВарианта));
	Если МассивСтрокВарианта.Количество() > 0 Тогда
		
		СтрокаВарианта = МассивСтрокВарианта[0];
		
		Если ПустаяСтрока(СтрокаВарианта.ИмяВарианта) Тогда
			ИмяВарианта = "Вариант " + НомерВарианта;
		Иначе
			ИмяВарианта = СтрокаВарианта.ИмяВарианта;
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат ИмяВарианта;
		
КонецФункции// ПолучитьИмяВариантаПоНомеру(НомерВарианта)

// Создает команду и кнопку для варианта.
//
&НаСервере
Процедура СоздатьКнопкуВарианта(ИДНовогоВарианта, ЗаголовокКнопки)
	
	// создадим команду
	НоваяКоманда = Команды.Добавить("КомандаВариант" + ИДНовогоВарианта);
	НоваяКоманда.Заголовок = ЗаголовокКнопки;
	НоваяКоманда.Подсказка = НСтр("ru = 'Выбрать вариант'");
	НоваяКоманда.Действие  = "ПанельВариантовВыбратьВариант";
	
	// создадим кнопку
	НовыйЭлемент = Элементы.Добавить("Вариант" + ИДНовогоВарианта, Тип("КнопкаФормы"), Элементы.КоманднаяПанельВариантов);
	НовыйЭлемент.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
	НовыйЭлемент.Заголовок = ЗаголовокКнопки;
	НовыйЭлемент.ИмяКоманды = НоваяКоманда.Имя;
	
	// Переместим в конец коллекции кнопку создания нового варианта.
	Элементы.Переместить(Элементы.КнопкаДобавитьВариант, Элементы.КоманднаяПанельВариантов);
КонецПроцедуры // СоздатьКнопкуВарианта()

&НаКлиенте
Процедура КомандаДобавитьВариант(Команда)
		// Получим номер нового варианта.
	НовыйНомерВарианта = ПолучитьИдентификаторВарианта();
	СписокИменВариантов.Добавить(НовыйНомерВарианта, "Вариант "+НовыйНомерВарианта);
	
	// Добавим кнопку нового варианта на панель вариантов.
	СоздатьКнопкуВарианта(НовыйНомерВарианта, СтрЗаменить(НСтр("ru = 'Вариант %Номер%'"), "%Номер%", НовыйНомерВарианта));
	ПанельВариантовВыбратьВариант(Команды["КомандаВариант" + НовыйНомерВарианта]);

КонецПроцедуры

// Формирует кнопки, "разделяющие" табличную часть Пункты по вариантам.
//
&НаСервере
Процедура СформироватьПанельВариантов()
	
	ТаблицаВариантов = Объект.Пункты.Выгрузить();
	ТаблицаВариантов.Свернуть("ИДВарианта");
	ТаблицаВариантов.Сортировать("ИДВарианта");
	
	Если ТаблицаВариантов.Количество() = 0 Тогда // Создадим одну кнопку "по умолчанию"
		// создадим кнопку "по умолчанию".
		СоздатьКнопкуВарианта(1, НСтр("ru = 'Вариант 1'"));
		Возврат;
	Иначе
		СписокИменВариантов.Очистить();
	КонецЕсли;
		
	// Заполним список имен вариантов.
	Для Каждого СтрокаТаблицы Из ТаблицаВариантов Цикл
		СписокИменВариантов.Добавить(СтрокаТаблицы.ИДВарианта, ПолучитьИмяВариантаПоНомеру(СтрокаТаблицы.ИДВарианта));
	КонецЦикла;	
		
	Для Сч = 0 По ТаблицаВариантов.Количество()-1 Цикл

		СоздатьКнопкуВарианта(ТаблицаВариантов[Сч].ИДВарианта, СписокИменВариантов.НайтиПоЗначению(ТаблицаВариантов[Сч].ИДВарианта).Представление);

	КонецЦикла;
	
	// Найдем утвержденный вариант.
	УтвержденныеСтроки = Объект.Пункты.НайтиСтроки(Новый Структура("Утвержден",Истина));
	ТекИДВарианта = ?(УтвержденныеСтроки.Количество() = 0, 0, УтвержденныеСтроки[0].ИДВарианта);
	
	Если ТекИДВарианта > 0 Тогда
		
		Кнопка = Элементы["Вариант"+ТекИДВарианта];
		Кнопка.Заголовок = Кнопка.Заголовок + НСтр("ru = ' (Утв.)'");
		ИДВарианта = ТекИДВарианта;
		
	Иначе
		// Сделаем активным первый вариант.
		ИДВарианта = ТаблицаВариантов[0].ИДВарианта;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имя варианта для занесения в табличную часть Пункты.
//
// Параметры:
//  НомерВарианта - Число - номер варианта;
//
// Возвращаемое значение:
//  Строка - если имя варианта стандартное, возвращает пустую строку, иначе - имя варианта.
//	
&НаСервере
Функция ИмяВариантаДляТабличнойЧасти(НомерВарианта)
	ИмяВарианта = СписокИменВариантов.НайтиПоЗначению(НомерВарианта).Представление;
	ИмяВарианта = ?(ИмяВарианта = "Вариант " + НомерВарианта, "", ИмяВарианта);
	Возврат ИмяВарианта;
КонецФункции

&НаКлиенте
// Проверяет, есть ли пункты, относящиеся к утвержденному варианту.
//
// Параметры:
//  СтруктураПараметров - Структура - может содержать следующие элементы:
// ВозвращаемоеЗначение:
//  Булево - Истина, если изменение табличной части "Пункты" разрешено.
//
Процедура РазрешеноИзменениеПунктов(СтруктураПараметров = Неопределено, ОписаниеОповещенияОЗавершении)
	
	Перем ПунктыТекущаяСтрока, ПроверитьВсеПункты;
	
	Если СтруктураПараметров = Неопределено Тогда
		СтруктураПараметров = Новый Структура("ПроверитьВсеПункты", Ложь);
	КонецЕсли;
	
	СтруктураПараметров.Свойство("ПунктыТекущаяСтрока", ПунктыТекущаяСтрока);
	Если Не СтруктураПараметров.Свойство("ПроверитьВсеПункты" , ПроверитьВсеПункты) Тогда
		ПроверитьВсеПункты = Ложь;
	КонецЕсли;
	
	ИДУтвержденногоВарианта = 0;
	Если ПунктыТекущаяСтрока = Неопределено Тогда
		
		Если ПроверитьВсеПункты Тогда
			
			ИндексСтроки = 0;
			ПунктыКоличествоСтрок = Объект.Пункты.Количество();
			
			Пока ИндексСтроки < ПунктыКоличествоСтрок И ИДУтвержденногоВарианта = 0 Цикл
				
				СтрокаПункты = Объект.Пункты[ИндексСтроки];
				
				Если СтрокаПункты.Утвержден Тогда
					ИДУтвержденногоВарианта = СтрокаПункты.ИДВарианта;
				КонецЕсли;
				
				ИндексСтроки = ИндексСтроки + 1;
				
			КонецЦикла;
		
		Иначе	
			
			// Проверим только текущий вариант.
			СтрокиТекущегоВарианта = Объект.Пункты.НайтиСтроки(Новый Структура("ИДВарианта",ИДВарианта));
			Если СтрокиТекущегоВарианта.Количество() > 0 Тогда
				СтрокаПункты = СтрокиТекущегоВарианта[0];
				Если СтрокаПункты.Утвержден Тогда
					ИДУтвержденногоВарианта = СтрокаПункты.ИДВарианта;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ПунктыТекущаяСтрока.Утвержден Тогда
		
		ИДУтвержденногоВарианта = ПунктыТекущаяСтрока.ИДВарианта;

	КонецЕсли;
	
	Если ИДУтвержденногоВарианта > 0 Тогда
		
		ИмяВарианта = СписокИменВариантов.НайтиПоЗначению(ИДУтвержденногоВарианта).Представление;
		
		ТекстВопроса =НСтр("ru = ' Вариант """ + ИмяВарианта + """ утвержден!
					   |При внесении изменений в таблицу пункты договоров
					   |статус ""Утвержден"" будет снят. Продолжить?'");
					   
		ОписаниеОповещения = Новый ОписаниеОповещения("РазрешеноИзменениеПунктовЗавершение", ЭтотОбъект, ОписаниеОповещенияОЗавершении);			   
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
        Возврат;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Истина); 
	
КонецПроцедуры// Функция РазрешеноИзменениеПунктов()

&НаКлиенте
Процедура РазрешеноИзменениеПунктовЗавершение(Ответ, ОписаниеОповещенияОЗавершении) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Для каждого КнопкаПанелиВариантов Из Элементы.КоманднаяПанельВариантов.ПодчиненныеЭлементы Цикл
			КнопкаПанелиВариантов.Заголовок = СтрЗаменить(КнопкаПанелиВариантов.Заголовок, НСтр("ru = ' (Утв.)'"), "");
		КонецЦикла;
		
		УтвержденныеСтроки = Объект.Пункты.НайтиСтроки(Новый Структура("Утвержден", Истина));
		Для Каждого Строка Из УтвержденныеСтроки Цикл
			Строка.Утвержден = Ложь;
		КонецЦикла;
		
		Элементы.КнопкаУтвердитьВариант.Пометка = Ложь;
		
		РазрешеноИзменение = Истина;
		
	Иначе
		
		РазрешеноИзменение = Ложь;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, РазрешеноИзменение); 
	
КонецПроцедуры// Функция РазрешеноИзменениеПунктов()

#КонецОбласти 


#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// установим текущий вариант
	КомандаТекущегоВарианта = Команды["КомандаВариант" + ИДВарианта];
	ПанельВариантовВыбратьВариант(КомандаТекущегоВарианта, Ложь);
	
	ТипДоговора = ПолучитьТипДоговора(Объект.ДоговорКонтрагента);
	ФормаДоговора = ПолучитьФормуДоговора(Объект.ДоговорКонтрагента);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
		
	// Работа с вариантами
	Если Объект.Пункты.Количество() = 0 Тогда
		СписокИменВариантов.Добавить(1, "Вариант 1");
	КонецЕсли;	
	ИДИзменяемогоВарианта = 0;
	ИДВарианта = 1;
	СписокЗагруженПриСменеВарианта = Ложь;
	
	СформироватьПанельВариантов();
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) И ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		Объект.Контрагент = Объект.ДоговорКонтрагента.Владелец;
	КонецЕсли;
	
	ЗаполнитьНомерСтрокиВарианта(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	скМеханизмЗапускаБизнесПроцессовОбъектовСервер.ФормаОбъектаПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект.Ссылка, Элементы.ГруппаЗапускБизнесПроцесса);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьНомерСтрокиВарианта(ЭтотОбъект);
	скМеханизмЗапускаБизнесПроцессовОбъектовСервер.ФормаОбъектаПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект.Ссылка, Элементы.ГруппаЗапускБизнесПроцесса);	
	
КонецПроцедуры


#КонецОбласти 


// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#Область Подключаемый_МеханизмЗапускаБизнесПроцессов

&НаКлиенте
Процедура Подключаемый_ЗапускБизнесПроцесса(Команда)
	скМеханизмЗапускаБизнесПроцессовОбъектовКлиент.ОбработкаКомандыЗапускаБизнесПроцесса(ЭтаФорма, Команда, Объект.Ссылка);
КонецПроцедуры // Подключаемый_ЗапускБизнесПроцесса()

#КонецОбласти

