## **ImageFeed** 

ImageFeed - Многостраничное приложение предназначено для просмотра изображений через API Unsplash.<br>
[Ссылки на макет в Figma](https://www.figma.com/file/HyDfKh5UVPOhPZIhBqIm3q/Image-Feed-(YP)?type=design&node-id=334-4892&mode=design&t=qRuAhxp4mWQrR8X1-0)<br>
[Unsplash API](https://unsplash.com/documentation)

Цели приложения:
- Просмотр бесконечной ленты картинок из Unsplash Editorial.
- Просмотр краткой информации из профиля пользователя.

# Краткое описание приложения
- В приложении обязательна авторизация через OAuth Unsplash.
- Главный экран состоит из ленты с изображениями. Пользователь может просматривать ее, добавлять и удалять изображения из избранного.
- Пользователи могут просматривать каждое изображение отдельно и делиться ссылкой на них за пределами приложения.
- У пользователя есть профиль с избранными изображениями и краткой информацией о пользователе.
- У приложения есть две версии: расширенная и базовая. В расширенной версии добавляется механика избранного и возможность лайкать фотографии при просмотре изображения на весь экран.

## **Примеры из приложения** 
<img src="https://github.com/KonstantinKirillOff/ImageFeed/assets/53314883/0d462048-86af-4261-9261-a9e2596dcf43" width="195" alt="image"/>  
<img src="https://github.com/KonstantinKirillOff/ImageFeed/assets/53314883/0e0419ff-b2f9-41ba-8104-e31d516989d3" width="195" alt="image"/> 
<img src="https://github.com/KonstantinKirillOff/ImageFeed/assets/53314883/3d4c0ae9-6642-411a-8ceb-548beed7d161" width="195" alt="image"/>
<img src="https://github.com/KonstantinKirillOff/ImageFeed/assets/53314883/e715c9f1-8b27-49c8-b585-60c74698bff7" width="195" alt="image"/>


## **Технические особенности**
- Авторизация работает через OAuth Unsplash и POST запрос для получения Auth Token.
- Приложение должно поддерживать устройства iPhone с iOS 13 или выше, предусмотрен только портретный режим.
- Все шрифты в приложении — системные


## **В разработке использовалось:**
- Sourcetree
- SplashScreen
- Авторизация с помощью OAuth 2.0
- Работа с Web view
- Работа с UITableView
- Работа с навигацией через TabBarController, NavigationController
- UIScrollView
- Swift Package Manager
- MVP
- Keychain
- URLSession
- JSON
- Пагинация при работе с сетью
- Concurrency
- Предотвращение race condition (DispatchQueue,
блокировка UI)
- Kingfisher
- CoreAnimation
- Charles Toolchain
- UnitTests/UITests
- Вёрстка кодом с помощью Auto Layout
- Figma
