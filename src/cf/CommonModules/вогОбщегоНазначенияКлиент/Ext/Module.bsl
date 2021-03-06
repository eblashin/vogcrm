
#Область ПрограммныйИнтерфейс

// Процедура - обработчик выполнения общей команды "вогОтправитьEMail"
//
// Параметры:
//	ПараметрКоманды				- Произвольный	- Параметр команды
//	ПараметрыВыполненияКоманды	- Структура		- Параметры выполнения команды
//
Процедура ОбработкаКомандыОтправитьEMail(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	Если НЕ ЗначениеЗаполнено(ПараметрКоманды) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо записать элемент!'"));
		Возврат;
	КонецЕсли;
	СписокОбъектов = Новый СписокЗначений;
	СписокОбъектов.Добавить(ПараметрКоманды);
	вогУправлениеСвязями.ЗаполнитьСвязанныеОбъекты(СписокОбъектов, ПараметрКоманды);
	ОтправитьВыбравEMail(СписокОбъектов);
	
КонецПроцедуры // ОбработкаКомандыОтправитьEMail()

// Процедура выполняет звонок после выбора номера телефона из списка номеров
//
// Параметры:
//	СписокОбъектов			- СписокЗначений	- Список объектов, для которых выбираются телефоны
//	ДанныеЗаполнения		- Структура			- Данные для заполнения создаваемого события
//
Процедура ОтправитьВыбравEMail(СписокОбъектов, ДанныеЗаполнения = Неопределено, Основание = Неопределено) Экспорт
	Если СписокОбъектов.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран получатель'"), 5);
		Возврат;
	КонецЕсли;
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДанныеЗаполнения",	ДанныеЗаполнения);
	// ++ VOG Солодов В.В. 22.06.2020 CRM-658
	Если Не Основание = Неопределено тогда
		ДополнительныеПараметры.Вставить("Основание", Основание);
	КонецЕсли;
	// -- VOG Солодов В.В. 22.06.2020
	
	СписокАдресов = ЗаполнитьСписокЭлектронныхАдресов(СписокОбъектов);	
	//START Кайдашов 05/03/20 CRM-421
	Если СписокАдресов.Количество() = 0 тогда
		Сообщить("Не нашли ни одного адреса e-mail");
	КонецЕсли;
	//END Кайдашов CRM-421
	Если СписокАдресов.Количество() = 2 Тогда
		ВыполнитьОтправкуEmail(СписокАдресов[0], ДополнительныеПараметры);
	Иначе	
		ОписаниеВыбора = Новый ОписаниеОповещения("ВыполнитьОтправкуEmail", вогОбщегоНазначенияКлиент, ДополнительныеПараметры); 
		СписокАдресов.ПоказатьВыборЭлемента(ОписаниеВыбора, НСтр("ru='Выбор адреса E-mail'"));
	КонецЕсли;
КонецПроцедуры // ОтправитьВыбравEMail()	

Функция ЗаполнитьСписокЭлектронныхАдресов(СписокОбъектов) Экспорт
	СписокАдресов = Новый СписокЗначений;
	ТекКонтакт = "";
	Для Каждого СтрокаКонтакт Из СписокОбъектов Цикл
		ЭлектронныеАдреса = вогОбщегоНазначенияВызовСервера.ПолучитьМассивЭлектронныхАдресов(СтрокаКонтакт.Значение);
		Для Каждого Адрес Из ЭлектронныеАдреса Цикл
			Значение = Новый Структура;
			Значение.Вставить("Контакт", СтрокаКонтакт.Значение);
			Значение.Вставить("Email", Адрес.Представление);
			Если НЕ (ТекКонтакт = СтрокаКонтакт.Значение)Тогда
				СписокАдресов.Добавить(Значение, СокрЛП(Адрес.ПредставлениеОбъекта));
				ТекКонтакт = СтрокаКонтакт.Значение;
				
			КонецЕсли;
			СписокАдресов.Добавить(Значение, "  " + СокрЛП(Адрес.Вид) + ": " + Адрес.Представление);
		КонецЦикла;
	КонецЦикла;
	Возврат СписокАдресов;
КонецФункции // ЗаполнитьСписокЭлектронныхАдресов()

Процедура ВыполнитьОтправкуEmail(ВыбранныйАдрес, ДополнительныеПараметры) Экспорт
	Если ВыбранныйАдрес = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран E-mail!'"), 5);
		Возврат;
	КонецЕсли;
	
	АдресЭлектроннойПочты = ВыбранныйАдрес.Значение.Email;
	
	СтрРезультат = CRM_ОбщегоНазначенияКлиентСервер.АнализАдресаЭП(АдресЭлектроннойПочты);
	Если СтрРезультат.КодОшибки<>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрРезультат.Сообщение);
		Возврат;
	КонецЕсли;
	
	СписокАдресов = Новый СписокЗначений;
	СписокАдресов.Добавить(ВыбранныйАдрес.Значение.Контакт, АдресЭлектроннойПочты);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("СписокАдресов", СписокАдресов);
	Если ДополнительныеПараметры.Свойство("ДанныеЗаполнения") И ДополнительныеПараметры.ДанныеЗаполнения.ЕстьФайлы тогда
		ПараметрыФормы.Вставить("Файлы", ДополнительныеПараметры.ДанныеЗаполнения.Файлы);
	КонецЕсли;
	
	// ++ VOG Солодов В.В. 22.06.2020 CRM-658
	Если ДополнительныеПараметры.Свойство("Основание") тогда
		ПараметрыФормы.Вставить("Основание", ДополнительныеПараметры.Основание);
	КонецЕсли;
	// -- VOG Солодов В.В. 22.06.2020
	
	ОткрытьФорму("Документ.ЭлектронноеПисьмоИсходящее.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры // ВыполнитьОтправкуEmail()

#Область СтатусыСогласования

Процедура ОбработкаНажатияСтатусаСогласования(Форма) Экспорт
	
	РегистраторСтатуса = Форма.РегистраторСтатуса;
	Если ЗначениеЗаполнено(РегистраторСтатуса) Тогда
		//++ Бей 26072019 #470
		ОткрытьФорму("ОбщаяФорма.CRM_ОписаниеБизнесПроцесса",Новый Структура("ОбъектОтбора", РегистраторСтатуса));
		//ПоказатьЗначение(, РегистраторСтатуса);
		//--
		
	Иначе	
		ПоказатьПредупреждение(, НСтр("ru = 'Согласован за рамками системы.'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура РасшифрокаВнешниеДанныеМакет(Параметры) Экспорт // ++ Тищенко В.В.
	
	КлиентРасшифровка 	= Параметры.Получить("КлиентРасшифровка");
	СерверРасшифровка	= Параметры.Получить("СерверРасшифровка");
	Параметры 			= вогОбщегоНазначенияВызовСервера.РасшифрокаВнешниеДанныеМакетСервер(Параметры,СерверРасшифровка);
	Попытка
		Если ЗначениеЗаполнено(КлиентРасшифровка) Тогда
			Выполнить(КлиентРасшифровка);
		КонецЕсли;	
	Исключение
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки; 
	
КонецПроцедуры // -- Тищенко В.В.

#КонецОбласти


//START Кайдашов 02/07/19
Функция ПечатьКарточкиМероприятия(ОписаниеКоманды) Экспорт
	
	Состояние(НСтр("ru = 'Выполняется формирование печатных форм'"));
		
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.CRM_Мероприятие","КарточкаМероприятия",
			ОписаниеКоманды.ОбъектыПечати, );
		
	Состояние(НСтр("ru = 'Формирование печатных форм завершено'"));
	
КонецФункции
//END Кайдашов

// ++ VOG Солодов В.В. 27.08.2019 

// Процедура позволяет установить период через стандартный диалог выбора периода
//
// Параметры:
// 	Объект 					- Произвольный - Объект в котором устанавливается значения периода
// 	ПараметрыПериода 		- Структура - структура со свойствами "ДатаНачала", "ДатаОкончания" и в значениях имена полей
// 								объекта, для свойства "Вариант" - значение варианта стандартного периода.
// 	ОповещениеПослеВыбора 	- ОписаниеОповещения - Описание оповещение которое выполняется после установки периода. 
// 								Может быть установлена пост-обработка в месте вызова после выбора периода.
//
Процедура РедактироватьПериод(Объект, ПараметрыПериода = Неопределено, ОповещениеПослеВыбора = Неопределено) Экспорт
	
	Если ПараметрыПериода = Неопределено Тогда
		ПараметрыПериода = Новый Структура("ДатаНачала, ДатаОкончания", "ДатаНачала", "ДатаОкончания");
	КонецЕсли;
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	
	Если ПараметрыПериода.Свойство("ДатаНачала") Тогда
		Диалог.Период.ДатаНачала = Объект[ПараметрыПериода.ДатаНачала];
	КонецЕсли;
	Если ПараметрыПериода.Свойство("ДатаОкончания") Тогда
		Диалог.Период.ДатаОкончания = Объект[ПараметрыПериода.ДатаОкончания];
	КонецЕсли;
	Если ПараметрыПериода.Свойство("Вариант") Тогда
		Диалог.Период.Вариант = ПараметрыПериода.Вариант;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", 				Объект);
	ДополнительныеПараметры.Вставить("ПараметрыПериода", 	ПараметрыПериода);
	
	Если ОповещениеПослеВыбора <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ОповещениеПослеВыбора", ОповещениеПослеВыбора);
	КонецЕсли; 
	
	Оповещение = Новый ОписаниеОповещения(
		"РедактироватьПериодЗавершение",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	Диалог.Показать(Оповещение);

КонецПроцедуры

// Процедура завершения для РедактироватьПериод()
// см. подробней для процедуры РедактироватьПериод().
Процедура РедактироватьПериодЗавершение(Период, ДополнительныеПараметры) Экспорт 

	ПараметрыПериода 	= ДополнительныеПараметры.ПараметрыПериода;
	Объект 				= ДополнительныеПараметры.Объект;
	
	Если Период <> Неопределено Тогда
		Если ПараметрыПериода.Свойство("ДатаНачала") Тогда
			Объект[ПараметрыПериода.ДатаНачала]= Период.ДатаНачала;
		КонецЕсли;
		Если ПараметрыПериода.Свойство("ДатаОкончания") Тогда
			Объект[ПараметрыПериода.ДатаОкончания]= Период.ДатаОкончания;
		КонецЕсли;
		Если ПараметрыПериода.Свойство("Вариант") Тогда
			Объект[ПараметрыПериода.Вариант]= Период.Вариант;
		КонецЕсли;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ОповещениеПослеВыбора") Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыбора, Период);
	КонецЕсли;
	
КонецПроцедуры
// -- VOG Солодов В.В. 27.08.2019



