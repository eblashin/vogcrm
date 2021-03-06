
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторВопроса = Параметры.ИдентификаторВопроса;
	СхемаДанныхВопроса   = Параметры.СхемаДанныхВопроса;
	
	Если Параметры.Свойство("ОтборСтрок") Тогда
		Если ТипЗнч(Параметры.ОтборСтрок) = Тип("ФиксированнаяСтруктура") Тогда
			ОтборСтрок = Новый Структура;
			Для каждого КлючЗначениеОтбора Из Параметры.ОтборСтрок Цикл
				ОтборСтрок.Вставить(КлючЗначениеОтбора.Ключ, КлючЗначениеОтбора.Значение); 	
			КонецЦикла;
		Иначе	
			ОтборСтрок = Параметры.ОтборСтрок;
		КонецЕсли;
		
		ТаблицаВопроса = Параметры.ТаблицаВопроса.НайтиСтроки(ОтборСтрок); 	
		
	Иначе	
		ТаблицаВопроса = Параметры.ТаблицаВопроса; 	
		
	КонецЕсли;
	
	ИнициализироватьДанныеВопроса(ТаблицаВопроса);
		
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
	
	МассивИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Элемент.Имя, "__");
	
	ИдентификаторВарианта = МассивИмени[0];
	ИдентификаторСтроки   = МассивИмени[МассивИмени.ВГраница()];
	
	ДанныеВариантовОтветов = СхемаДанныхВопроса.СтруктураВариантовОтветов;	
	ДанныеВариантаОтвета   = ДанныеВариантовОтветов.Получить(ИдентификаторВарианта);
	Если ДанныеВариантаОтвета <> Неопределено Тогда
		Если ДанныеВариантаОтвета.ТипОтвета = ПредопределенноеЗначение("Перечисление.вогТипыОтветов.Одиночный") Тогда
			Для каждого КлючЗначение Из ДанныеВариантовОтветов Цикл
				Если КлючЗначение.Ключ = ИдентификаторВарианта Тогда
					ПриИзмененииДанныхВопросаКлиент(Элемент.Имя);
					Продолжить;
					
				КонецЕсли;
				
				ЭтотОбъект[КлючЗначение.Ключ + "__" + ИдентификаторСтроки] = Ложь;	
				ПриИзмененииДанныхВопросаКлиент(КлючЗначение.Ключ + "__" + ИдентификаторСтроки);
				
			КонецЦикла;
		
		КонецЕсли;		
	
	КонецЕсли;
		
КонецПроцедуры // Подключаемый_ВариантОтветаПриИзменении()

&НаКлиенте
Процедура Подключаемый_ДопИнформацияПриИзменении(Элемент)
	ПриИзмененииДанныхВопросаКлиент(Элемент.Имя);
КонецПроцедуры // Подключаемый_ДопИнформацияПриИзменении()

#КонецОбласти

#Область ВспомогательныеПроцедурыФункции

&НаСервере
Процедура ИнициализироватьДанныеВопроса(ТаблицаВопроса)

	ИмяОписания		 = ИдентификаторВопроса;
	СтруктураВопроса = СхемаДанныхВопроса.СтруктураВопроса;  	
	
	Заголовок = СтруктураВопроса.Вопрос;
	
	//Формирование реквизитов
	МассивДобавляемыхРеквизитов = Новый Массив;
	Для каждого СтрокаВопроса Из ТаблицаВопроса Цикл
		ИдентификаторЭлемента = СтрЗаменить(СтрокаВопроса.ИдентификаторСтроки, "-", "_");
		
		МассивДобавляемыхРеквизитов.Добавить(
			Новый РеквизитФормы("ФайлКартинкиАдрес__" + ИдентификаторЭлемента, Новый ОписаниеТипов("Строка")));	
			
		Для каждого КлючЗначение Из СхемаДанныхВопроса.СтруктураВариантовОтветов Цикл
			ОписаниеВариантаОтвета = КлючЗначение.Значение;
			ИмяКолонки = "ВариантОтвета_" + ИдентификаторЭлемента(ОписаниеВариантаОтвета.ВариантОтвета);	
			
			МассивДобавляемыхРеквизитов.Добавить(
				Новый РеквизитФормы(ИмяКолонки + "__" + ИдентификаторЭлемента, Новый ОписаниеТипов("Булево")));	

		КонецЦикла;	
		
		Для каждого ОписаниеСвойства Из СтруктураВопроса.ДополнительнаяИнформация Цикл
			ИмяКолонки = "ДополнительнаяИнформация" + ИмяОписания + "_" + ИдентификаторЭлемента(ОписаниеСвойства.Свойство) + "__" + ИдентификаторЭлемента;
			МассивДобавляемыхРеквизитов.Добавить(
				Новый РеквизитФормы(ИмяКолонки, ОписаниеСвойства.ТипЗначения));
			
		
		КонецЦикла;
		
	КонецЦикла;
	
	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
		
	Сч = 1;
	ФормироватьГруппу = Истина;
	
	//Формирование элементов
	ОбластьДобавления = Элементы.ОсновнаяОбласть;
	Для каждого СтрокаВопроса Из ТаблицаВопроса Цикл
		ИдентификаторЭлемента = СтрЗаменить(СтрокаВопроса.ИдентификаторСтроки, "-", "_");
		
		Попытка
			ДанныеФайлаКартинки = ПрисоединенныеФайлы.ПолучитьДанныеФайла(СтрокаВопроса.ОбъектОпроса, УникальныйИдентификатор);
			СсылкаНаДвоичныеДанныеФайла = ДанныеФайлаКартинки.СсылкаНаДвоичныеДанныеФайла;
		Исключение
		КонецПопытки;
		
		Если ЭтоАдресВременногоХранилища(СсылкаНаДвоичныеДанныеФайла) Тогда
			ЭтотОбъект["ФайлКартинкиАдрес__" + ИдентификаторЭлемента] = СсылкаНаДвоичныеДанныеФайла;
			
		КонецЕсли;
		
		Если ФормироватьГруппу Тогда
			ГруппаЭлементов = СоздатьНайтиОбычнуюГруппу("ГруппаЭлементов_" + ИдентификаторЭлемента, 
				ОбластьДобавления,
				ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная,
				ОтображениеОбычнойГруппы.Нет
			);
			
			ФормироватьГруппу = Ложь;
			
		КонецЕсли;
		
		ГруппаЭлемента = СоздатьНайтиОбычнуюГруппу("ГруппаЭлемента_" + ИдентификаторЭлемента, 
			ГруппаЭлементов,
			ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная,
			ОтображениеОбычнойГруппы.Нет
		);
				
		ЭлементФайлКартинки 				   = Элементы.Добавить("ФайлКартинкиАдрес__" + ИдентификаторЭлемента, Тип("ПолеФормы"), ГруппаЭлемента);
		ЭлементФайлКартинки.Вид				   = ВидПоляФормы.ПолеКартинки;
		ЭлементФайлКартинки.ПутьКДанным 	   = "ФайлКартинкиАдрес__" + ИдентификаторЭлемента;
		ЭлементФайлКартинки.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		ЭлементФайлКартинки.РазмерКартинки	   = РазмерКартинки.Пропорционально;
		ЭлементФайлКартинки.Подсказка 		   = СтрокаВопроса.ОбъектОпроса;
		ЭлементФайлКартинки.ТекстНевыбраннойКартинки = НСтр("ru = 'нет изображения'");

		ЭлементФайлКартинки.РастягиватьПоГоризонтали = Ложь;
		ЭлементФайлКартинки.РастягиватьПоВертикали   = Ложь;
		ЭлементФайлКартинки.Ширина					 = 10;
		ЭлементФайлКартинки.Высота					 = 7;
		
		ГруппаДействий = СоздатьНайтиОбычнуюГруппу("ГруппаДействий_" + ИдентификаторЭлемента, 
			ГруппаЭлемента,
			ГруппировкаПодчиненныхЭлементовФормы.Вертикальная,
			ОтображениеОбычнойГруппы.Нет
		);
		
		ГруппаВариантыОтвета = СоздатьНайтиОбычнуюГруппу("ГруппаВариантыОтвета_" + ИдентификаторЭлемента, 
			ГруппаДействий,
			ГруппировкаПодчиненныхЭлементовФормы.Вертикальная,
			ОтображениеОбычнойГруппы.Нет
		);
		
		ГруппаДопИнформация = СоздатьНайтиОбычнуюГруппу("ГруппаДопИнформация_" + ИдентификаторЭлемента, 
			ГруппаДействий,
			ГруппировкаПодчиненныхЭлементовФормы.Вертикальная,
			ОтображениеОбычнойГруппы.ОбычноеВыделение,,,
			НСтр("ru = 'Доп. информация'")
		);
		
		//Элементы вариантов ответа
		Для каждого КлючЗначение Из СхемаДанныхВопроса.СтруктураВариантовОтветов Цикл
			ОписаниеВариантаОтвета = КлючЗначение.Значение;
			ИдентификаторЭлементаВариантОтвета = "ВариантОтвета_" + ИдентификаторЭлемента(ОписаниеВариантаОтвета.ВариантОтвета);
			
			ИмяКолонки = ИдентификаторЭлементаВариантОтвета + "__" + ИдентификаторЭлемента;	
			
			Элемент					   = Элементы.Добавить(ИмяКолонки, Тип("ПолеФормы"), ГруппаВариантыОтвета);
			Элемент.Вид                = ВидПоляФормы.ПолеФлажка;
			Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
			Элемент.Заголовок		   = ОписаниеВариантаОтвета.ВариантОтвета;
			Элемент.ПутьКДанным        = ИмяКолонки;

			Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ВариантОтветаПриИзменении");
			ЭтотОбъект[ИмяКолонки] = СтрокаВопроса[ИдентификаторЭлементаВариантОтвета];
			
		КонецЦикла;	
				
		//Доп. информация
		Для каждого ОписаниеСвойства Из СтруктураВопроса.ДополнительнаяИнформация Цикл
			ИдентификаторЭлементаДопИнформации = "ДополнительнаяИнформация" + ИмяОписания + "_" + ИдентификаторЭлемента(ОписаниеСвойства.Свойство);
			ИмяКолонкиСвойства = ИдентификаторЭлементаДопИнформации + "__" + ИдентификаторЭлемента;			
			
			Элемент	= Элементы.Добавить(ИмяКолонкиСвойства, Тип("ПолеФормы"), ГруппаДопИнформация);
			Если ОбщегоНазначения.ОписаниеТипаСостоитИзТипа(ОписаниеСвойства.ТипЗначения, Тип("Булево")) Тогда
				Элемент.Вид				   = ВидПоляФормы.ПолеФлажка;
				Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
				
			Иначе	
				Элемент.Вид = ВидПоляФормы.ПолеВвода;
				
				ПараметрыВыбораЗначений = Новый Массив;
				ПараметрыВыбораЗначений.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ОписаниеСвойства.Свойство));
				Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораЗначений);
				
			КонецЕсли;
			
			Элемент.Заголовок	 = ОписаниеСвойства.Свойство;
			Элемент.ПутьКДанным  = ИмяКолонкиСвойства;

			Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ДопИнформацияПриИзменении");
			ЭтотОбъект[ИмяКолонкиСвойства] = СтрокаВопроса[ИдентификаторЭлементаДопИнформации];
			
		КонецЦикла;
		
		Если Сч % 4 = 0 Тогда
			ФормироватьГруппу = Истина;
			
		КонецЕсли;
		Сч = Сч + 1;
		
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

#КонецОбласти
