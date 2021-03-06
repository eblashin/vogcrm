
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
    КоличествоКолонок           = Параметры.КоличествоКолонок;
	КоличествоСтрокВКолонке     = Параметры.КоличествоСтрокВКолонке;;
	ИдентификаторВопроса        = Параметры.ИдентификаторВопроса;
	//СхемаДанныхВопроса          = Параметры.СхемаДанныхВопроса;
	
	ИнициализироватьДанныеВопроса(Параметры.ТаблицаВопроса);
	
КонецПроцедуры	
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрименитьИЗакрыть(Команда)

КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеПроцедурыФункции

&НаКлиенте
Процедура Подключаемый_ВариантОтветаПриИзменении(Элемент)
	ПриИзмененииДанныхВопросаКлиент(Элемент.Имя);
КонецПроцедуры // Подключаемый_ВариантОтветаПриИзменении()

&НаКлиенте
Процедура Подключаемый_ДопИнформацияПриИзменении(Элемент)
	ПриИзмененииДанныхВопросаКлиент(Элемент.Имя);
КонецПроцедуры // Подключаемый_ДопИнформацияПриИзменении()

#КонецОбласти

#Область ВспомогательныеПроцедурыФункции

&НаСервере
Процедура ИнициализироватьДанныеВопроса(ТаблицаВопроса)
	Для Каждого СтрокаВопроса из ТаблицаВопроса Цикл
		
		СтрокаТаблицы = ТаблицаДанных.Добавить();
		СтрокаТаблицы.Артикул = СтрокаВопроса.НоменклатураАртикул;
		СтрокаТаблицы.Дизайн  = СтрокаВопроса.НоменклатураВогКоллекцияНоменклатурыРодитель;
		СтрокаТаблицы.Бренд   = СтрокаВопроса.НоменклатураВогКоллекцияНоменклатурыРодительРодитель;
		
		
	КонецЦикла;
	
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблДанных.Дизайн КАК Дизайн1,
	               |	ТаблДанных.Артикул КАК Артикул1,
	               |	ТаблДанных.Бренд КАК Бренд1
	               |ПОМЕСТИТЬ ДанныеВопроса
	               |ИЗ
	               |	&таблицаДанных КАК ТаблДанных
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДанныеВопроса.Дизайн1 КАК ЭтоДизайн,
	               |	ДанныеВопроса.Артикул1 КАК Артикул,
	               |	ДанныеВопроса.Бренд1 КАК Бренд
	               |ИЗ
	               |	ДанныеВопроса КАК ДанныеВопроса
	               |ИТОГИ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Артикул)
	               |ПО
	               |	Бренд,
	               |	ЭтоДизайн";
	Запрос.УстановитьПараметр("ТаблицаДанных", ТаблицаДанных.Выгрузить());
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Выборка.Следующий() Цикл
		
		Стр = ТаблицаДанных1.Добавить();
		Стр.Артикул = Выборка.Бренд;
		Стр.Бренд = Истина;
		Стр.Количество = Выборка.Артикул;
		ВыборкаДизайны = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаДизайны.Следующий() Цикл
			Стр = ТаблицаДанных1.Добавить();
			Стр.Артикул = ВыборкаДизайны.ЭтоДизайн;
			Стр.Дизайн = Истина;
			Стр.Количество = ВыборкаДизайны.Артикул;

			ВыборкаАртикулы = ВыборкаДизайны.Выбрать();
			Пока ВыборкаАртикулы.Следующий() Цикл
				Стр = ТаблицаДанных1.Добавить();
				Стр.Артикул = ВыборкаАртикулы.Артикул;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	
	

			
КонецПроцедуры // ИнициализироватьДанныеВопроса()

&НаКлиенте
Процедура ПриИзмененииДанныхВопросаКлиент(ИмяЭлемента)

	МассивИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяЭлемента, "__");
	
	ИдентификаторКолонки = МассивИмени[0];
	ИдентификаторСтроки  = МассивИмени[МассивИмени.ВГраница()];
	
	Параметр = Новый Структура;
	Параметр.Вставить("ИдентификаторВопроса" , ИдентификаторВопроса);
	Параметр.Вставить("ИдентификаторСтроки"  , СтрЗаменить(ИдентификаторСтроки, "_", "-"));
	Параметр.Вставить("ИмяКолонки"			 , ИдентификаторКолонки);
	Параметр.Вставить("Значение"			 , ЭтотОбъект[ИмяЭлемента]);
		
	Оповестить("ОбработкаСтрокиВопроса", Параметр, ЭтотОбъект);
			
КонецПроцедуры // ПриИзмененииДанныхВопросаКлиент()

&НаСервере
Функция СоздатьНайтиОбычнуюГруппу(ИмяГруппы,
						   		Родитель = Неопределено,
						   		Группировка = Неопределено,
						   		Отображение = Неопределено, 
						   		РастягиватьПоГоризонтали = Неопределено,
						   		РастягиватьПоВертикали = Неопределено,
						   		ЗаголовокГруппы = "")
						   	
	Группа = Элементы.Найти(ИмяГруппы);
	Если Группа = Неопределено Тогда
		Группа   		   		  		= Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"), ?(Родитель = Неопределено, ЭтаФорма, Родитель));	
		Группа.Вид		   		  		= ВидГруппыФормы.ОбычнаяГруппа;	
		Группа.Группировка 		  		= ?(Группировка = Неопределено, ГруппировкаПодчиненныхЭлементовФормы.Вертикальная, Группировка);
		Группа.Отображение 		   		= ?(Отображение = Неопределено, ОтображениеОбычнойГруппы.Нет, Отображение);
		Группа.ОтображатьЗаголовок 		= ЗначениеЗаполнено(ЗаголовокГруппы);	
		Группа.Заголовок 				= ЗаголовокГруппы;
		Группа.РастягиватьПоГоризонтали = РастягиватьПоГоризонтали;
		Группа.РастягиватьПоВертикали   = РастягиватьПоВертикали;
		
	КонецЕсли;
	
	Возврат Группа;	
	
КонецФункции // СоздатьНайтиГруппу()

&НаСервереБезКонтекста
Функция ИдентификаторЭлемента(Ссылка)

	Возврат СтрЗаменить(Ссылка.УникальныйИдентификатор(), "-", "_");	
	
КонецФункции // ИдентификаторЭлемента()

&НаКлиенте
Процедура ПечатьДокумента(Команда)
//ЭтотОбъект.пе	
ТабДок = ПечатьДокументаНаСервере();
ТабДок.Показать();
КонецПроцедуры

&НаСервере
Функция ПечатьДокументаНаСервере()
//ЭтотОбъект.пе	
ТабДок = Документы.вогАнкета.Печать(КоличествоСтрокВКолонке,КоличествоКолонок, ТаблицаДанных1);
Возврат ТабДок;
КонецФункции


//Процедура Печать(КоличествоСтрокВКолонке,КоличествоКолонок, Таблица) Экспорт
//	//Таблица = ЭтотОбъект.ТаблицаВопроса.Выгрузить();
//	
//	
//	Таб = Новый ТабличныйДокумент;
//	Таб.Очистить();
//	
//	Макет = ЭтотОбъект.ПолучитьМакет("Макет");
//	
//	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
//	ОбластьПробелМеждуКолонками = Макет.ПолучитьОбласть("ПробелМуждуКолонок");
//	ОбластьСтрок = Макет.ПолучитьОбласть("Строка");
//	
//	ОбщееКоличествоСтрок = Таблица.Количество();
//	КоличествоНаСтранице = КоличествоКолонок * КоличествоСтрокВКолонке;
//	КолНаСтранице = 0;
//	СтрокВКолонке = КоличествоСтрокВКолонке;
//	
//	КолСтраниц = ОбщееКоличествоСтрок / КоличествоНаСтранице;
//	
//	Если Цел(КолСтраниц) < КолСтраниц Тогда
//		КолСтраниц = Цел(КолСтраниц) + 1;
//	КонецЕсли;	
//	
//	Для Страница = 1 По КолСтраниц Цикл
//		
//		Для Строка = 1 По СтрокВКолонке Цикл
//			
//			// Выводим основную часть
//			ПолучСтрока = Таблица[КолНаСтранице + Строка - 1];
//			
//			ОбластьСтрок.Параметры.НомерСтроки = ПолучСтрока.НомерСтроки;
//			ОбластьСтрок.Параметры.Данные = ПолучСтрока.Данные;
//			
//			Таб.Вывести(ОбластьСтрок);
//			
//			// Добавяем колонки
//			Если КоличествоКолонок > 1 Тогда
//				
//				СуммаКолонки = 0;
//				
//				Для Кол = 1 По (КоличествоКолонок - 1) Цикл
//					Таб.Присоединить(ОбластьПробелМеждуКолонками);
//					
//					Попытка
//						// Добавляем остальные части
//						ПолучСтрока = Таблица[СуммаКолонки+ КолНаСтранице + СтрокВКолонке + Строка - 1];
//						ОбластьСтрок.Параметры.НомерСтроки = ПолучСтрока.НомерСтроки;
//						ОбластьСтрок.Параметры.Данные = ПолучСтрока.Данные;
//						
//						Таб.Присоединить(ОбластьСтрок);
//						
//						СуммаКолонки = СуммаКолонки + СтрокВКолонке;
//					Исключение
//						
//					КонецПопытки;
//					
//				КонецЦикла;
//			КонецЕслИ;
//		КонецЦикла;
//		
//		КолНаСтранице = КолНаСтранице + КоличествоНаСтранице;
//		Таб.ВывестиГоризонтальныйРазделительСтраниц();
//		
//	КонецЦикла;
//	
//	Таб.Показать();
//КонецПроцедуры


#КонецОбласти
