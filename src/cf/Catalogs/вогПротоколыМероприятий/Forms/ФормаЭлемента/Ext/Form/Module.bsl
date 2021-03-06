
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	ТолькоПросмотр = Истина;
	Элементы.СрокИсполненияПроцесса.ТолькоПросмотр = Истина;
	Элементы.СрокОбработкиРезультатовПредставление.ТолькоПросмотр = Истина;
	
	
	ОтборОбсуждения = Новый ОтборОбсужденийСистемыВзаимодействия;
	ОтборОбсуждения.КонтекстОбсуждения = Новый КонтекстОбсужденияСистемыВзаимодействия(ПолучитьНавигационнуюСсылку(Объект.Ссылка));
	ОтборОбсуждения.КонтекстноеОбсуждение = Истина;
	СписокОбсуждений = СистемаВзаимодействия.ПолучитьОбсуждения(ОтборОбсуждения);
	Если СписокОбсуждений.Количество()>0 тогда
		Элементы.ГруппаЕстьОбсуждение.Видимость = Истина;
	Иначе
		Элементы.ГруппаЕстьОбсуждение.Видимость = Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	вогНастройкиБизнесПроцессов.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.вогНастройкиБизнесПроцессов КАК вогНастройкиБизнесПроцессов
	               |ГДЕ
	               |	НЕ вогНастройкиБизнесПроцессов.ПометкаУдаления
	               |	И вогНастройкиБизнесПроцессов.Повестка
	               |	И НЕ вогНастройкиБизнесПроцессов.ТорговыеТочки 
	               |	И НЕ вогНастройкиБизнесПроцессов.Клиенты ";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() тогда
		НастройкаБП = Выборка.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаФормы()
	
	Элементы.СтраницаИсполнители.Видимость = Объект.НесколькоИсполнителейПоПункту;
	Элементы.Ответственный.ТолькоПросмотр = Объект.НесколькоИсполнителейПоПункту;
	Элементы.СрокИсполненияПроцесса.ТолькоПросмотр = Объект.НесколькоИсполнителейПоПункту;
	
КонецПроцедуры



&НаКлиенте
Процедура СрокИсполненияПроцессаПриИзменении(Элемент)

	ДопПараметры = вогСрокиИсполненияПроцессовКлиент.ДопПараметрыДляИзмененияСрокаПоПредставлению();
	ДопПараметры.Форма = ЭтаФорма;
	ДопПараметры.Поле = "СрокИсполненияПроцессаПредставление";
	ДопПараметры.НаименованиеИзмененногоРеквизита = "СрокИсполненияПроцесса";
	ДопПараметры.Исполнитель = Объект.Ответственный;
	
	вогСрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияУчастникаПроцессаПоПредставлению(
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		СрокОбработкиРезультатовПредставление,
		ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПроцессаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораСрока = вогУправлениеИнтерфейсомКлиент.ПараметрыВыбораСрока();
	ПараметрыВыбораСрока.Форма = ЭтаФорма;
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполнения = "СрокИсполненияПроцесса";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияДни = "СрокИсполненияПроцессаДни";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияЧасы = "СрокИсполненияПроцессаЧасы";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияМинуты = "СрокИсполненияПроцессаМинуты";
	ПараметрыВыбораСрока.ИмяРеквизитаПредставлениеСрока = "СрокИсполненияПроцессаПредставление";
	ПараметрыВыбораСрока.ИмяОбъектаФормы = "Объект";
	ПараметрыВыбораСрока.СрокиПредшественников = Объект.Исполнители;
	ПараметрыВыбораСрока.НаименованиеСрокаУчастника = "СрокИсполненияПроцесса";
	ПараметрыВыбораСрока.Участник = Объект.Проверяющий;
	
	вогСрокиИсполненияПроцессовКлиент.ВыбратьСрокУчастникаПроцесса(ПараметрыВыбораСрока);
	
КонецПроцедуры


&НаСервере
Процедура ОбновитьСрокиИсполненияНаСервере(ОбновитьВсеСроки = Ложь) Экспорт
	
	вогСрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// см. ОбновитьСрокиИсполненияНаСервере
&НаКлиенте
Процедура ОбновитьСрокиИсполнения()
	
	ОбновитьСрокиИсполненияНаСервере();
	
КонецПроцедуры

// см. ОбновитьСрокиИсполнения
&НаКлиенте
Процедура ОбновитьСрокиИсполненияОтложенно(РеквизитТаблица = "", ИндексСтроки = 0) Экспорт
	
	РеквизитТаблицаСИзмененнымСроком = РеквизитТаблица;
	ИндексСтрокиСИзмененнымСроком = ИндексСтроки;
	
	ПодключитьОбработчикОжидания("ОбновитьСрокиИсполнения", 0.2, Истина);
	
КонецПроцедуры

// Заполняет представление сроков исполнения в карточке процесса.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеСроковИсполнения() Экспорт
	
	вогСрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	
	ПараметрыВыбораСрока = вогУправлениеИнтерфейсомКлиент.ПараметрыВыбораСрока();
	ПараметрыВыбораСрока.Форма = ЭтаФорма;
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполнения = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияДни = "СрокОбработкиРезультатовДни";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияЧасы = "СрокОбработкиРезультатовЧасы";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияМинуты = "СрокОбработкиРезультатовМинуты";
	ПараметрыВыбораСрока.ИмяРеквизитаПредставлениеСрока = "СрокОбработкиРезультатовПредставление";
	ПараметрыВыбораСрока.ИмяОбъектаФормы = "Объект";
	ПараметрыВыбораСрока.СрокиПредшественников = Объект.Исполнители;
	ПараметрыВыбораСрока.НаименованиеСрокаУчастника = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.Участник = Объект.Проверяющий;
	
	вогСрокиИсполненияПроцессовКлиент.ВыбратьСрокУчастникаПроцесса(ПараметрыВыбораСрока);
	
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеПриИзменении(Элемент)
	
	ДопПараметры = вогСрокиИсполненияПроцессовКлиент.ДопПараметрыДляИзмененияСрокаПоПредставлению();
	ДопПараметры.Форма = ЭтаФорма;
	ДопПараметры.Поле = "СрокОбработкиРезультатовПредставление";
	ДопПараметры.НаименованиеИзмененногоРеквизита = "СрокОбработкиРезультатов";
	ДопПараметры.Исполнитель = Объект.Ответственный;
	
	вогСрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияУчастникаПроцессаПоПредставлению(
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		СрокОбработкиРезультатовПредставление,
		ДопПараметры);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ПараметрыОповещения = Новый Структура("Мероприятие, ПунктПротокола,НомерПункта", Объект.Мероприятие, Объект.Ссылка,Объект.НомерПунктаПрограммы);
	Оповестить("Запись_ПунктПротокола", ПараметрыОповещения);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСрокИсполненияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РеквизитИсполнители = Объект.Исполнители;
	ТекущиеДанные = Элементы.Исполнители.ТекущиеДанные;
	
	НомерСтроки = РеквизитИсполнители.Индекс(ТекущиеДанные) + 1;
	
	ДатаОтсчета = ДатаОтсчетаДляРасчетаСроков;
	
	
	ИмяПоляПорядокИсполнения = "ПорядокИсполнения";
	
	МаксимальныйСрокЭтапа = Дата(1,1,1);
	
	НомерПервойСтрокиИсполнителя = 1;
	
	Для Каждого СтрИсполнитель Из РеквизитИсполнители Цикл
		
		// Определим строку ответственного исполнителя и пропустим ее обработку.
		Если вогСрокиИсполненияПроцессовКлиентСервер.ЭтоСтрокаОтвественного(СтрИсполнитель) Тогда
			НомерПервойСтрокиИсполнителя = 2;
			Продолжить;
		КонецЕсли;
		
		СтрИсполнительНомерСтроки = РеквизитИсполнители.Индекс(СтрИсполнитель) + 1;
		
		Если СтрИсполнительНомерСтроки = НомерСтроки Тогда
			Прервать;
		КонецЕсли;
		
		МаксимальныйСрокЭтапа = Макс(СтрИсполнитель.СрокИсполнения, МаксимальныйСрокЭтапа);
		
	КонецЦикла;
	
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("ВариантИсполнения", Неопределено);
	ДопПараметры.Вставить("ЭлементИсполнители", Элементы.Исполнители);
	ДопПараметры.Вставить("РеквизитИсполнители", РеквизитИсполнители);
	ДопПараметры.Вставить("Форма", ЭтаФорма);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьВыборСрокаИсполненияДляСтрокиТаблицыИсполнители",вогУправлениеМероприятиямиКлиентСервер
		, ДопПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Исполнитель", ТекущиеДанные.Исполнитель);
	ПараметрыФормы.Вставить("СрокИсполнения", ТекущиеДанные.СрокИсполнения);
	ПараметрыФормы.Вставить("ДатаОтсчета", ДатаОтсчета);
	
	ОткрытьФорму("ОбщаяФорма.ВыборСрокаИсполнения",
		ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	

КонецПроцедуры


&НаКлиенте
Процедура ИсполнителиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Исполнители.ТекущиеДанные<>Неопределено и Элементы.Исполнители.ТекущиеДанные.Ответственный тогда
		Элементы.ИсполнителиЭтоОтветственныйИсполнитель.Пометка = Истина;
	Иначе
		Элементы.ИсполнителиЭтоОтветственныйИсполнитель.Пометка = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры


&НаКлиенте
Процедура ЭтоОтветственныйИсполнитель(Команда)
	
	Если Элементы.Исполнители.ТекущиеДанные<>Неопределено тогда	
		Элементы.Исполнители.ТекущиеДанные.Ответственный = истина;	
		Элементы.ИсполнителиЭтоОтветственныйИсполнитель.Пометка = Истина;
		
		Для каждого Строка из Объект.Исполнители цикл
			Если Строка.Ответственный и строка.НомерСтроки<>Элементы.Исполнители.ТекущиеДанные.НомерСтроки тогда
				Строка.Ответственный = Ложь;	
			КонецЕсли;
		КонецЦикла;
		
		Объект.Ответственный = Элементы.Исполнители.ТекущиеДанные.Исполнитель; 
		Объект.СрокИсполненияПроцесса = Элементы.Исполнители.ТекущиеДанные.СрокИсполнения; 
		Объект.СрокИсполненияПроцессаДни = Элементы.Исполнители.ТекущиеДанные.СрокИсполненияДни; 
		Объект.СрокИсполненияПроцессаЧасы = Элементы.Исполнители.ТекущиеДанные.СрокИсполненияЧасы; 
		Объект.СрокИсполненияПроцессаМинуты = Элементы.Исполнители.ТекущиеДанные.СрокИсполненияМинуты; 
		СрокИсполненияПроцессаПредставление = Элементы.Исполнители.ТекущиеДанные.СрокИсполненияПредставление; 
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СостояниеИсполненияПриИзменении(Элемент)
	Объект.СостояниеИсполненияУстановил = ПользователиКлиентСервер.ТекущийПользователь();
КонецПроцедуры


&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)

	Объект.СрокОбработкиРезультатов = Объект.СрокОбработкиРезультатов + 600*Направление;
	СрокОбработкиРезультатовПредставление = Формат(Объект.СрокОбработкиРезультатов,"ДФ='dd.MM.yy HH:mm'; ДП='%1'"); 
	
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастройкаФормы();
	
	МассивОб = Новый Массив;
	МассивОб.Добавить(Объект.Ссылка);
	МассивБП = вогУправлениеМероприятиямиВызовСервера.НайтиПорученияПоПротоколам(МассивОб);
	Если МассивБП.Количество() = 0 тогда
		Элементы.ФормаПорученияПоПунктуПротокола.Заголовок = "Создать поручение";	
	Иначе
		Элементы.ФормаПорученияПоПунктуПротокола.Заголовок = "Поручения";	
	КонецЕсли;
	
	
	
КонецПроцедуры


&НаКлиенте
Процедура НесколькоИсполнителейПоПунктуПриИзменении(Элемент)
	
	НастройкаФормы();
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Объект.НесколькоИсполнителейПоПункту тогда
		Объект.Исполнители.Очистить();
		Строка = Объект.Исполнители.Добавить();	
		Строка.Исполнитель = Объект.Ответственный;
		Строка.Ответственный = Истина;
		Строка.СрокИсполнения = Объект.СрокИсполненияПроцесса;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СрокИсполненияПроцессаРегулирование(Элемент, Направление, СтандартнаяОбработка)

	Объект.СрокИсполненияПроцесса= Объект.СрокИсполненияПроцесса + 600*Направление;
	СрокИсполненияПроцессаПредставление = Формат(Объект.СрокИсполненияПроцесса,"ДФ='dd.MM.yy HH:mm'; ДП='%1'"); 

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиФайлы(Команда)
	
	ИмяКоманды = Команда.Имя;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла",  Объект.Ссылка);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтаФорма.ТолькоПросмотр);
	
	Если вогУправлениеПрисоединеннымиФайламиКлиентСерверПовтИсп.ИспользоватьРедактированиеПрисоединенныхФайловПоВидам(Объект.Ссылка) Тогда
		ФормаИмя = "ОбщаяФорма.вогФормаУправленияПрисоединеннымиФайлами";
		ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Присоединенные файлы'"))
	Иначе	
		ФормаИмя = "ОбщаяФорма.ПрисоединенныеФайлы";
	КонецЕсли;
	
	
	ПараметрыПереходаПоГиперссылке = Новый Структура;
	ПараметрыПереходаПоГиперссылке.Вставить("ИмяФормы", ФормаИмя);
	ПараметрыПереходаПоГиперссылке.Вставить("ПараметрыФормы",ПараметрыФормы);
	ПараметрыПереходаПоГиперссылке.Вставить("РежимОткрытияОкнаФормы", РежимОткрытияОкнаФормы.Независимый);
	
	ГиперссылкаПерейтиСформироватьПараметрыИВопрос(ПараметрыПереходаПоГиперссылке);

КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПерейтиСформироватьПараметрыИВопрос(ПараметрыПереходаПоГиперссылке)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = Нстр("ru = 'Данные еще не записаны.
		|Переход к дополнительной информции возможен только после записи элемента.
		|Записать элемент?'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ГиперссылкаПерейтиВопросЗавершение", ЭтотОбъект, ПараметрыПереходаПоГиперссылке), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ГиперссылкаПерейти(ПараметрыПереходаПоГиперссылке);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПерейтиВопросЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ЭлементЗаписан = Записать();
	Исключение
		Возврат;
	КонецПопытки;
	
	Если Не ЭлементЗаписан Тогда
		Возврат;
	КонецЕсли;
	
	ГиперссылкаПерейти(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПерейти(ПараметрыПереходаПоГиперссылке)
	
	//Оповещение = Новый ОписаниеОповещения("ГиперссылкаПереходЗавершение",ЭтаФорма,Элементы.СтраницыКарточкаОбъекта.ТекущаяСтраница.Имя);
	
	ОткрытьФорму(ПараметрыПереходаПоГиперссылке.ИмяФормы,
		ПараметрыПереходаПоГиперссылке.ПараметрыФормы, , ЭтаФорма.УникальныйИдентификатор, , , ,
		ПараметрыПереходаПоГиперссылке.РежимОткрытияОкнаФормы);
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	ПараметрыОповещения = Новый Структура("Мероприятие, ПунктПротокола,НомерПункта", Объект.Мероприятие, Объект.Ссылка,Объект.НомерПунктаПрограммы);
	Оповестить("Обновить_ПунктПротокола", ПараметрыОповещения);

КонецПроцедуры


&НаКлиенте
Процедура СрокИсполненияПроцессаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	СрокИсполненияПроцессаНачалоВыбора(Элемент,ДанныеВыбора,СтандартнаяОбработка);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры


&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	СрокОбработкиРезультатовПредставлениеНачалоВыбора(Элемент,ДанныеВыбора,СтандартнаяОбработка);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры



&НаКлиенте
Процедура ПорученияПоПунктуПротокола(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) тогда
		Возврат;
	КонецЕсли;
	
	МассивОб = Новый Массив;
	МассивОб.Добавить(Объект.Ссылка);
	МассивБП = вогУправлениеМероприятиямиВызовСервера.НайтиПорученияПоПротоколам(МассивОб);
	Если МассивБП.Количество() = 0 тогда
		Оповещение = Новый ОписаниеОповещения("СоздатьПоручениеВопросЗавершение",ЭтотОбъект);
		ПоказатьВопрос(Оповещение,"Создать новое поручение?",РежимДиалогаВопрос.ДаНет);
	Иначе
		
		ОткрытьФорму("ОбщаяФорма.СтруктураПодчиненности",Новый Структура("ОбъектОтбора", Объект.Ссылка),
				ЭтотОбъект,
				ЭтотОбъект.КлючУникальности,);
			
	КонецЕсли;
		
	
КонецПроцедуры

&НаКлиенте                                                                       
Процедура СоздатьПоручениеВопросЗавершение(Результат,Параметры) экспорт
	
	Если Результат = КодВозвратаДиалога.Да тогда
		Если НастройкаБП.Пустая() тогда
			Сообщение=Новый СообщениеПользователю;
			Сообщение.Текст = "Укажите настройку для Поручения";
			Сообщение.Поле = "Элементы.Настройка";
			Сообщение.ПутьКДанным = "Элементы.НастройкаБП";
			Сообщение.Сообщить();
			Возврат;
		КонецЕслИ;
		Результат = СоздатьПоручениеНаСервере();	
		Если Результат.ТекстОшибки<>"" тогда
			Сообщить("Произошла ошибка " + Результат.ТекстОшибки);
		Иначе	
			Элементы.ФормаПорученияПоПунктуПротокола.Заголовок = "Поручения";	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьПоручениеНаСервере()
	
	ПараметрыБП = вогУправлениеМероприятиямиКлиентСервер.ПараметрыНастройкиБизнесПроцессаПоручение();
	ПараметрыБП.Настройка = НастройкаБП;
	Если НЕ Объект.Проверяющий.Пустая() тогда
		ПараметрыБП.КонтролироватьВыполнение = Истина;
		ПараметрыБП.ДатаКонтроля = Объект.СрокОбработкиРезультатов;
		ПараметрыБП.Контролер = Объект.Проверяющий;
	Иначе
		ПараметрыБП.КонтролироватьВыполнение = Ложь;
		ПараметрыБП.ДатаКонтроля = Объект.СрокИсполненияПроцесса;
		ПараметрыБП.Контролер = Объект.Проверяющий;
	КонецЕсли;
	Если Объект.НесколькоИсполнителейПоПункту тогда
		НачатьТранзакцию();
		Для каждого СтрокаИсполнителя из Объект.Исполнители цикл
			ПараметрыБП.ДатаИсполнения = СтрокаИсполнителя.СрокИсполнения;
			ПараметрыБП.Исполнитель = СтрокаИсполнителя.Исполнитель;
			ПараметрыБП.Наименование = "Задача по мероприятию " + Объект.Мероприятие;
			ПараметрыБП.Описание = ?(СтрокаИсполнителя.Задача<>"",СтрокаИсполнителя.Задача,"выполнить задачи по пункту " + Объект.НомерПунктаПрограммы);
			РезультатСоздания = вогУправлениеМероприятиямиВызовСервера.СоздатьПоручениеПоПунктуПротокола(Объект.Ссылка,ПараметрыБП);	
			Если РезультатСоздания.ТекстОшибки<>"" тогда
				Сообщить("Произошла ошибка при создании поручения для " + СтрокаИсполнителя.Исполнитель + Символы.ВК + Символы.ПС + РезультатСоздания.ТекстОшибки);
				РезультатСоздания.ТекстОшибки="";
				ОтменитьТранзакцию();
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Иначе
		ПараметрыБП.ДатаИсполнения = Объект.СрокИсполненияПроцесса;
		ПараметрыБП.Исполнитель = Объект.Ответственный;
		ПараметрыБП.Наименование = "Задача по мероприятию " + Объект.Мероприятие;
		ПараметрыБП.Описание = ?(Объект.Решили<>"",Объект.Решили,"выполнить задачи по пункту " + Объект.НомерПунктаПрограммы);
		РезультатСоздания = вогУправлениеМероприятиямиВызовСервера.СоздатьПоручениеПоПунктуПротокола(Объект.Ссылка,ПараметрыБП);	
		Возврат РезультатСоздания;
	КонецЕсли;
КонецФункции