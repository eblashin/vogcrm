////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
// Функция возвращает текущего пользователя.
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	СправочникСсылка	- Текущий пользователь.
//
Функция ТекущийПользователь()
	Возврат Пользователи.ТекущийПользователь();
КонецФункции // ТекущийПользователь()

&НаСервере
Функция ДобавитьВТаблицуСоответствийИменВложенийИдентификаторамКартинкиИзИнтернета(ПереданныйТекстHTML)
	
	ДокументHTML = Взаимодействия.ПолучитьОбъектДокументHTMLИзТекстаHTML(ПереданныйТекстHTML);
	
	Для каждого Картинка Из ДокументHTML.Картинки Цикл
		
		АтрибутИсточникКартинки = Картинка.Атрибуты.ПолучитьИменованныйЭлемент("src");
		Если АтрибутИсточникКартинки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрЧислоВхождений(АтрибутИсточникКартинки.ТекстовоеСодержимое, "://") > 0 Тогда
			РезультатСкаченногоФайла = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(АтрибутИсточникКартинки.ТекстовоеСодержимое);
			
			Если НЕ РезультатСкаченногоФайла = Неопределено И РезультатСкаченногоФайла.Статус Тогда
				НоваяКартинка = Новый Картинка(ПолучитьИзВременногоХранилища(РезультатСкаченногоФайла.Путь));
				
				НоваяСтрока = ТаблицаСоответствийИменВложенийИдентификаторам.Добавить();
				НоваяСтрока.ИмяФайла = АтрибутИсточникКартинки.ТекстовоеСодержимое;
				НоваяСтрока.ИдентификаторФайлаДляHTML = Новый УникальныйИдентификатор;
				НоваяСтрока.Картинка = НоваяКартинка;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		
		СтруктураВложений = Новый Структура;
		Объект.Текст = Взаимодействия.ОбработатьТекстHTMLДляФорматированногоДокумента(
			Объект.Ссылка, Объект.Текст,СтруктураВложений);
		ФорматированныйДокументТекст.УстановитьHTML(Объект.Текст, СтруктураВложений);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(Объект.Владелец) Тогда
		Объект.Владелец = ТекущийПользователь();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Пользователь) Тогда
		Объект.Пользователь = ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ДокументHTMLТекущегоПисьмаПодготовлен = Ложь;
	
	ТаблицаСоответствийИменВложенийИдентификаторам.Очистить();
	
	СтруктураВложений = Новый Структура;
	ФорматированныйДокументТекст.ПолучитьHTML(ТекущийОбъект.Текст, СтруктураВложений);
	
	ДобавитьВТаблицуСоответствийИменВложенийИдентификаторамКартинкиИзИнтернета(ТекущийОбъект.Текст);
	
	Для каждого Вложение Из СтруктураВложений Цикл
		
		НоваяСтрока = ТаблицаСоответствийИменВложенийИдентификаторам.Добавить();
		НоваяСтрока.ИмяФайла = Вложение.Ключ;
		НоваяСтрока.ИдентификаторФайлаДляHTML = Новый УникальныйИдентификатор;
		НоваяСтрока.Картинка = Вложение.Значение;
		
	КонецЦикла;
	
	Если ТаблицаСоответствийИменВложенийИдентификаторам.Количество() > 0 Тогда
		
		ДокументHTML = Взаимодействия.ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекущийОбъект.Текст);
		Взаимодействия.ЗаменитьИменаКартинокНаИдентификаторыПочтовыхВложенийВHTML(
		    ДокументHTML, ТаблицаСоответствийИменВложенийИдентификаторам.Выгрузить());
		ДокументHTMLТекущегоПисьмаПодготовлен = Истина;
		
	КонецЕсли;
	
	Если ДокументHTMLТекущегоПисьмаПодготовлен Тогда
		
		ТекущийОбъект.Текст = Взаимодействия.ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьПривилегированныйРежим(Истина);
	Письмо = ТекущийОбъект.Ссылка;
	
	// Добавим в список удаленных вложений ранее сохраненные картинки, отображаемые в теле форматированного документа.
	ТаблицаВложенийКартинокФорматированногоДокумента = Взаимодействия.ПолучитьВложенияПисьмаСНеПустымИД(Письмо);
	Для каждого Вложение Из ТаблицаВложенийКартинокФорматированногоДокумента Цикл
		УдаленныеВложения.Добавить(Вложение.Ссылка);
	КонецЦикла;
	
	// Удалим удаленные вложения
	Для Каждого УдаленноеВложение Из УдаленныеВложения Цикл
		ОбъектВложение = УдаленноеВложение.Значение.ПолучитьОбъект();
		ОбъектВложение.Удалить();
	КонецЦикла;
	
	УдаленныеВложения.Очистить();
	
	Для каждого Вложение Из ТаблицаСоответствийИменВложенийИдентификаторам Цикл
		
		ИмяФайлаВложения = "_" + СтрЗаменить(Вложение.ИдентификаторФайлаДляHTML, "-", "_") + "." + Вложение.Картинка.Формат();
		
		ДвоичныеДанныеКартинки = Вложение.Картинка.ПолучитьДвоичныеДанные();
		АдресКартинкиВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанныеКартинки, УникальныйИдентификатор);
		ПрисоединенныйФайл = CRM_УправлениеЭлектроннойПочтой.ЗаписатьВложениеЭлектронногоПисьмаИзВременногоХранилища(
		                     Письмо,
		                     АдресКартинкиВоВременномХранилище,
		                     ИмяФайлаВложения,
		                     ДвоичныеДанныеКартинки.Размер());
		
		Если ПрисоединенныйФайл <> Неопределено Тогда
			ПрисоединенныйФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
			ПрисоединенныйФайлОбъект.ИДФайлаЭлектронногоПисьма = Вложение.ИдентификаторФайлаДляHTML;
			ПрисоединенныйФайлОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
