# BOOKIFY

![Bookify Logo](docs/design/images/bookify.png)

**Bookify is a cross-platform Flutter application designed to help users organize their personal library, track reading progress and manage book loans with a scalable and maintainable architecture.**

## 🎨 Design

The design was created with [Figma](https://www.figma.com/file/EGg9eFK0Hi8LaVQcPVnjrX/Bookify-Edoardo?node-id=0%3A1)

## ✨ Features

**⚠️ APPLICATION STILL UNDER DEVELOPMENT. More features will be added in the future.**

For technical documentation (build and architecture), read [build_and_architecture](docs/design/build_and_architecture.md).

### 📙 Search Books

This page you can search for books by title, author, category, publisher, and ISBN.
Tapping the book icon, you can choose the type of search you can do: Title, Author, Genre, Publisher, and ISBN.

![Screenshot_1](docs/design/images/Screenshot_1.png)

Tapping on a book will open another page where it specifies the book detailing its characteristics.

![Screenshot_2](docs/design/images/Screenshot_2.png)

Tapping on the **Plus** icon will open the page to scan the ISBN. Yes you will have to give permission to be able to use the device camera. If for any reason the camera cannot find the code, you can click in the **write manually** button and you can write the code manually.

![Screenshot_3](docs/design/images/Screenshot_3.png)
![Screenshot_4](docs/design/images/Screenshot_4.png)

### 🗄️ Bookcase

Clicking on **Bookcases**, you will be redirected to the page for viewing your bookcase. When you don't have any, you can add them by clicking on the **+ Add a new shelf button**.

![Screenshot_5](docs/design/images/Screenshot_5.png)

On this page you can add your Bookcase information.

![Screenshot_6](docs/design/images/Screenshot_6.png)
![Screenshot_7](docs/design/images/Screenshot_7.png)

When you finish creating the bookcase, you will return to the previous page with the new bookcase ready for use.

![Screenshot_8](docs/design/images/Screenshot_8.png)

You then place the books you saved earlier on the bookcase, to be able to sort them for future uses.

![Screenshot_9](docs/design/images/Screenshot_9.png)
![Screenshot_10](docs/design/images/Screenshot_10.png)
![Screenshot_11](docs/design/images/Screenshot_11.png)

### 📚 My Books

To find out which books you have saved before you can go to the **My Books** section to see your book collection.

![Screenshot_12](docs/design/images/Screenshot_12.png)

### 🤝 Loans

Now that your shelves are ready, you can lend your books to your friends, family, etc. To start a loan, go to the **loans** section and click on the **+ Add new loan** button.

![Screenshot_13](docs/design/images/Screenshot_13.png)

As with the **bookcase**, you can enter your **loan** information, adding the book from your shelf or separate along with the contact who should receive the book.

![Screenshot_14](docs/design/images/Screenshot_14.png)
![Screenshot_15](docs/design/images/Screenshot_15.png)

Once entered, you can see the **loan** information by clicking on it.

![Screenshot_16](docs/design/images/Screenshot_16.png)
![Screenshot_17](docs/design/images/Screenshot_17.png)

### 📖 Readings

To start a reading, click on the **readings** button, then click on the **+ Add new Reading** button. Once clicked, a bottom sheet menu will appear where you can choose the book.
**Note:** A particular book will be readable if it is not on loan. Just like a book on loan cannot be read.

![Screenshot_18](docs/design/images/Screenshot_18.png)
![Screenshot_19](docs/design/images/Screenshot_19.png)

Once you have selected the book, you will be able to read it. To do this, you will need to click on the **Continue Reading** button and you will be redirected to the timer page where you can start reading. When you are finished, you will need to update your reading by moving the sidebar cursor to the pages you have read and then clicking on **Update Reading**.

![Screenshot_20](docs/design/images/Screenshot_20.png)
![Screenshot_21](docs/design/images/Screenshot_21.png)
![Screenshot_22](docs/design/images/Screenshot_22.png)

### ⚙️ Settings

On the **settings** page you can change the theme, update the reading time per page and the reading time.

    1. Change Theme: This option will make you change the theme to light, dark and system.
    2. Reading Time: This option will make you read a text where an average time will be calculated to complete a book.
    3. Hour Time: This option will let you choose the time and when it should repeat and then notify you at that time and the chosen time will be used as default in the reading timer.

![Screenshot_23](docs/design/images/Screenshot_23.png)

#### Reading Time

![Screenshot_24](docs/design/images/Screenshot_24.png)
![Screenshot_25](docs/design/images/Screenshot_25.png)

#### Hour Time

![Screenshot_26](docs/design/images/Screenshot_26.png)
![Screenshot_27](docs/design/images/Screenshot_27.png)
![Screenshot_28](docs/design/images/Screenshot_28.png)

## 📱iOS

[iOS Screenshots](docs/design/images/ios/)

## 👥 Team

1. [Fredson - Designer](https://www.linkedin.com/in/fredsoncosta/)
2. [Edoardo - Developer](https://www.linkedin.com/in/edoardofabrizio/)
