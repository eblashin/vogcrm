// В данный модуль вынесены методы подсистемы CRM, вызываемые из модулей типовых объектов. 
// Выносить можно только те методы, которые не вызывают стандартные методы типового модуля или обработчики форм. 
// Т.е. вызывают только те методы, что тоже вынесены из типового или не содержат таких вызовов.

// Для каждого объекта необходимо задать свою #Область с именем объекта и модуля, как он называется в метаданных.

#Область Обработка_ПереносФайловВТома_Форма

Функция ПеренестиФайлВТом(ВерсияСтруктура, МаксимальныйРазмерФайла, МассивФайловСОшибками) Экспорт
	
	Перем СсылкаНаТом;
	
	КодВозврата = Истина;
	
	ВерсияСсылка = ВерсияСтруктура.Ссылка;
	ФайлСсылка = ВерсияСтруктура.Ссылка;
	
	Размер = ВерсияСтруктура.Размер;
	ИмяДляЖурнала = "";
	
	Если Размер > МаксимальныйРазмерФайла Тогда
		
		ИмяДляЖурнала = ВерсияСтруктура.Текст;
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Файлы.Ошибка переноса файла в том'"),
			УровеньЖурналаРегистрации.Информация,
			,
			ФайлСсылка,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При переносе в том файла
				           |""%1""
				           |возникла ошибка:
				           |""Размер превышает максимальный"".'"),
				ИмяДляЖурнала));
		
		Возврат Ложь; // ничего не сообщаем 
	КонецЕсли;
	
	ИмяДляЖурнала = ВерсияСтруктура.Текст;
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Файлы.Начат перенос файла в том'"),
		УровеньЖурналаРегистрации.Информация,
		,
		ФайлСсылка,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Начат перенос в том файла
			           |""%1"".'"),
			ИмяДляЖурнала));
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ФайлСсылка);
	Исключение
		Возврат Ложь; // ничего не сообщаем 
	КонецПопытки;
	
	Попытка
		
		ТипХраненияФайла = ФайлСсылка.ТипХраненияФайла;
		
		Если ТипХраненияФайла <> Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
			// Тут файл на диске - так не должно быть.
			РазблокироватьДанныеДляРедактирования(ФайлСсылка);
			Возврат Ложь;
		КонецЕсли;
		
		НачатьТранзакцию();
		
		ФайлОбъект = ФайлСсылка.ПолучитьОбъект();
			
		ХранилищеФайла = ФайлОбъект.ФайлХранилище;
		
		ДвоичныеДанныеФайла = РаботаСФайлами.ДвоичныеДанныеФайла(ФайлСсылка);
		
		СведенияОФайле = РаботаСФайламиСлужебный.ДобавитьФайлВТом(ДвоичныеДанныеФайла,
																   ФайлСсылка.ДатаМодификацииУниверсальная,
																   ФайлСсылка.Наименование,
																   ФайлСсылка.Расширение,
																   1,
																   ФайлСсылка.Зашифрован,
																   ФайлСсылка.ДатаМодификацииУниверсальная);
		
		ФайлОбъект.ПутьКФайлу = СведенияОФайле.ПутьКФайлу;
		ФайлОбъект.Том = СведенияОФайле.Том;
		ФайлОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
		ФайлОбъект.ФайлХранилище = Новый ХранилищеЗначения("");
		// Чтобы прошла запись ранее подписанного объекта.
		ФайлОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
		ФайлОбъект.Записать();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Файлы.Завершен перенос файла в том'"),
			УровеньЖурналаРегистрации.Информация,
			,
			ФайлСсылка,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Завершен перенос в том файла
				           |""%1"".'"),
				ИмяДляЖурнала));
		
		ЗафиксироватьТранзакцию();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ОтменитьТранзакцию();
		
		СтруктураОшибки = Новый Структура;
		СтруктураОшибки.Вставить("ИмяФайла", ИмяДляЖурнала);
		СтруктураОшибки.Вставить("Ошибка",   КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		СтруктураОшибки.Вставить("Версия",   ВерсияСсылка);
		
		МассивФайловСОшибками.Добавить(СтруктураОшибки);
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Файлы.Ошибка переноса файла в том'"),
			УровеньЖурналаРегистрации.Информация,
			,
			ФайлСсылка,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При переносе в том файла
				           |""%1""
				           |возникла ошибка:
				           |""%2"".'"),
				ИмяДляЖурнала,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке) ));
				
		КодВозврата = Ложь;
		
	КонецПопытки;
	
	РазблокироватьДанныеДляРедактирования(ФайлСсылка);
	РазблокироватьДанныеДляРедактирования(ВерсияСсылка);
	
	Возврат КодВозврата;
	
КонецФункции

#КонецОбласти

#Область Обработка_CRM_Календарь_Форма

Функция ПолучитьИзбранныхПолучателей() Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Запрос.Текст = "ВЫБРАТЬ
	               |	CRM_ИзбранныеПолучатели.Получатель
	               |ИЗ
	               |	РегистрСведений.CRM_ИзбранныеПолучатели КАК CRM_ИзбранныеПолучатели
	               |ГДЕ
	               |	CRM_ИзбранныеПолучатели.Пользователь = &Пользователь
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	CRM_ИзбранныеПолучатели.Получатель.Наименование";
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Получатель");
КонецФункции // ПолучитьИзбранныхПолучателей()

#КонецОбласти

