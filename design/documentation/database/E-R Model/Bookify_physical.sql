CREATE TABLE
    Book (
        id String PRIMARY KEY,
        title String,
        publisher String,
        description String,
        page_count int,
        image_url String,
        buy_link String,
        average_rating int,
        rating_count int
    );

CREATE TABLE
    Reading (
        id int PRIMARY KEY,
        pages_readed int,
        fk_Book_id String
    );

CREATE TABLE
    Loan (
        id int PRIMARY KEY,
        observation String,
        loan_date Date,
        devolution_date Date
    );

CREATE TABLE
    People (mobile_number String PRIMARY KEY);

CREATE TABLE
    Author (id int PRIMARY KEY, name String);

CREATE TABLE
    Category (id int PRIMARY KEY, name String);

CREATE TABLE
    BookCase (
        id int PRIMARY KEY,
        name String,
        color String,
        category String
    );

CREATE TABLE
    loan_to_the_person (fk_Loan_id int, fk_People_mobile_number String);

CREATE TABLE
    authors_book (fk_Book_id String, fk_Author_id int);

CREATE TABLE
    categories_book (fk_Book_id String, fk_Category_id int);

CREATE TABLE
    book_loan (fk_Book_id String, fk_Loan_id int);

CREATE TABLE
    book_on_case (fk_Book_id String, fk_BookCase_id int);

ALTER TABLE Reading ADD CONSTRAINT FK_Reading_2 FOREIGN KEY (fk_Book_id) REFERENCES Book (id) ON DELETE CASCADE;

ALTER TABLE loan_to_the_person ADD CONSTRAINT FK_loan_to_the_person_1 FOREIGN KEY (fk_Loan_id) REFERENCES Loan (id) ON DELETE RESTRICT;

ALTER TABLE loan_to_the_person ADD CONSTRAINT FK_loan_to_the_person_2 FOREIGN KEY (fk_People_mobile_number) REFERENCES People (mobile_number) ON DELETE RESTRICT;

ALTER TABLE authors_book ADD CONSTRAINT FK_authors_book_1 FOREIGN KEY (fk_Book_id) REFERENCES Book (id) ON DELETE RESTRICT;

ALTER TABLE authors_book ADD CONSTRAINT FK_authors_book_2 FOREIGN KEY (fk_Author_id) REFERENCES Author (id) ON DELETE RESTRICT;

ALTER TABLE categories_book ADD CONSTRAINT FK_categories_book_1 FOREIGN KEY (fk_Book_id) REFERENCES Book (id) ON DELETE RESTRICT;

ALTER TABLE categories_book ADD CONSTRAINT FK_categories_book_2 FOREIGN KEY (fk_Category_id) REFERENCES Category (id) ON DELETE RESTRICT;

ALTER TABLE book_loan ADD CONSTRAINT FK_book_loan_1 FOREIGN KEY (fk_Book_id) REFERENCES Book (id) ON DELETE RESTRICT;

ALTER TABLE book_loan ADD CONSTRAINT FK_book_loan_2 FOREIGN KEY (fk_Loan_id) REFERENCES Loan (id) ON DELETE SET NULL;

ALTER TABLE book_on_case ADD CONSTRAINT FK_book_on_case_1 FOREIGN KEY (fk_Book_id) REFERENCES Book (id) ON DELETE RESTRICT;

ALTER TABLE book_on_case ADD CONSTRAINT FK_book_on_case_2 FOREIGN KEY (fk_BookCase_id) REFERENCES BookCase (id) ON DELETE SET NULL;