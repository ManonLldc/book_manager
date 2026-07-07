# Book Manager — Toutes les procédures

Application Ruby on Rails de gestion de livres à lire, avec CRUD complet, style et recherche.

---

## 📋 Fonctionnalités

Chaque livre possède :
- un **titre**
- un **auteur**
- un **statut** (À lire, En cours, Lu)
- une **date d'ajout** (gérée automatiquement)

CRUD complet :
- ✅ Créer un livre
- ✅ Afficher tous les livres
- ✅ Afficher le détail d'un livre
- ✅ Modifier un livre
- ✅ Supprimer un livre

---

## 1️⃣ Création du projet

```bash
rails new book_manager
cd book_manager
rails db:create
rails server
```

---

## 2️⃣ Générer le modèle

```bash
rails generate model Book title:string author:string status:string
rails db:migrate
```

---

## 3️⃣ Générer le contrôleur

```bash
rails generate controller Books
```

Les actions sont écrites à la main (pas de scaffold), pour comprendre le rôle de chaque fichier.

---

## 4️⃣ Routes

Dans `config/routes.rb` :

```ruby
Rails.application.routes.draw do
  resources :books
  root "books#index"
end
```

Grâce à `resources :books`, Rails crée automatiquement :

| Action  | URL             | Méthode |
|---------|-----------------|---------|
| Index   | /books          | GET     |
| Show    | /books/:id      | GET     |
| New     | /books/new      | GET     |
| Create  | /books          | POST    |
| Edit    | /books/:id/edit | GET     |
| Update  | /books/:id      | PATCH   |
| Destroy | /books/:id      | DELETE  |

---

## 5️⃣ Données de test

```bash
rails console
```

```ruby
Book.create(title: "Le Seigneur des Anneaux", author: "Tolkien", status: "À lire")
Book.create(title: "Harry Potter", author: "J.K Rowling", status: "Lu")
Book.create(title: "Dune", author: "Frank Herbert", status: "En cours")
exit
```

---

## 6️⃣ INDEX — Afficher la liste des livres

### Contrôleur

```ruby
class BooksController < ApplicationController
  def index
    @books = Book.all
  end
end
```

### Vue `app/views/books/index.html.erb` (version de base)

```erb
<h1>Mes livres</h1>

<table>
  <thead>
    <tr>
      <th>Titre</th>
      <th>Auteur</th>
      <th>Statut</th>
    </tr>
  </thead>

  <tbody>
    <% @books.each do |book| %>
      <tr>
        <td><%= book.title %></td>
        <td><%= book.author %></td>
        <td><%= book.status %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

Tester sur : `http://localhost:3000`

---

## 7️⃣ NEW + CREATE — Ajouter un livre

### Contrôleur

```ruby
class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to books_path, notice: "Livre ajouté avec succès"
    else
      render :new
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :status)
  end
end
```

### Vue `app/views/books/new.html.erb`

```erb
<h1>Ajouter un livre</h1>

<%= form_with model: @book, local: true do |form| %>

  <div>
    <%= form.label :title, "Titre" %>
    <%= form.text_field :title %>
  </div>

  <div>
    <%= form.label :author, "Auteur" %>
    <%= form.text_field :author %>
  </div>

  <div>
    <%= form.label :status, "Statut" %>
    <%= form.select :status, ["À lire", "En cours", "Lu"] %>
  </div>

  <div>
    <%= form.submit "Ajouter" %>
  </div>

<% end %>

<br>

<%= link_to "Retour à la liste", books_path %>
```

Lien "Nouveau livre" dans l'index :

```erb
<%= link_to "➕ Ajouter un livre", new_book_path %>
```

---

## 8️⃣ SHOW — Voir un livre

### Contrôleur

```ruby
def show
  @book = Book.find(params[:id])
end
```

### Vue `app/views/books/show.html.erb`

```erb
<h1>Détail du livre</h1>

<p><strong>Titre :</strong> <%= @book.title %></p>
<p><strong>Auteur :</strong> <%= @book.author %></p>
<p><strong>Statut :</strong> <%= @book.status %></p>

<br>

<%= link_to "Retour", books_path %> |
<%= link_to "Modifier", edit_book_path(@book) %>
```

---

## 9️⃣ EDIT + UPDATE — Modifier un livre

### Contrôleur

```ruby
def edit
  @book = Book.find(params[:id])
end

def update
  @book = Book.find(params[:id])

  if @book.update(book_params)
    redirect_to @book, notice: "Livre mis à jour"
  else
    render :edit
  end
end
```

### Vue `app/views/books/edit.html.erb`

```erb
<h1>Modifier le livre</h1>

<%= form_with model: @book, local: true do |form| %>

  <div>
    <%= form.label :title %>
    <%= form.text_field :title %>
  </div>

  <div>
    <%= form.label :author %>
    <%= form.text_field :author %>
  </div>

  <div>
    <%= form.label :status %>
    <%= form.select :status, ["À lire", "En cours", "Lu"] %>
  </div>

  <%= form.submit "Modifier" %>

<% end %>

<br>

<%= link_to "Retour", books_path %>
```

---

## 🔟 DESTROY — Supprimer un livre

### Contrôleur

```ruby
def destroy
  @book = Book.find(params[:id])
  @book.destroy

  redirect_to books_path, notice: "Livre supprimé"
end
```

---

## 1️⃣1️⃣ INDEX final — vue complète avec toutes les actions

```erb
<h1>Mes livres</h1>

<%= link_to "➕ Ajouter un livre", new_book_path %>

<table>
  <thead>
    <tr>
      <th>Titre</th>
      <th>Auteur</th>
      <th>Statut</th>
      <th>Actions</th>
    </tr>
  </thead>

  <tbody>
    <% @books.each do |book| %>
      <tr>
        <td><%= book.title %></td>
        <td><%= book.author %></td>
        <td><%= book.status %></td>

        <td>
          <%= link_to "Voir", book_path(book) %> |
          <%= link_to "Modifier", edit_book_path(book) %> |
          <%= link_to "Supprimer", book_path(book),
              data: { turbo_method: :delete, turbo_confirm: "Tu es sûr ?" } %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>
```

## 🎯 Résultat CRUD

- ✅ Create (new / create)
- ✅ Read (index / show)
- ✅ Update (edit / update)
- ✅ Delete (destroy)

---

## 1️⃣2️⃣ Style CSS

### Fichier `app/assets/stylesheets/books.css`

```css
body {
  font-family: Arial, sans-serif;
  background-color: #f4f6f8;
  margin: 0;
  padding: 20px;
}

h1 {
  color: #333;
  margin-bottom: 20px;
}

a {
  text-decoration: none;
  color: #2c7be5;
}

a:hover {
  text-decoration: underline;
}

/* Bouton ajouter */
a[href*="new"] {
  display: inline-block;
  padding: 10px 15px;
  background-color: #2c7be5;
  color: white;
  border-radius: 6px;
  margin-bottom: 15px;
}

a[href*="new"]:hover {
  background-color: #1a5dcc;
}

/* Table */
table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

thead {
  background-color: #2c7be5;
  color: white;
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

tr:hover {
  background-color: #f1f5ff;
}

/* Actions */
td a {
  margin-right: 8px;
}

/* Bouton supprimer */
a[data-turbo-method="delete"] {
  color: #e74c3c;
}

a[data-turbo-method="delete"]:hover {
  color: #c0392b;
}
```

### Inclusion dans `app/assets/stylesheets/application.css`

```css
@import "books";
```

---

## 1️⃣3️⃣ Gestion des données (console Rails)

### Supprimer tous les livres

```ruby
# Rapide, sans callbacks
Book.delete_all

# Plus "Rails safe", déclenche les callbacks
Book.destroy_all
```

### Créer 50 livres automatiquement

```ruby
50.times do |i|
  Book.create(
    title: "Livre #{i + 1}",
    author: "Auteur #{i + 1}",
    status: ["À lire", "En cours", "Lu"].sample
  )
end
```

### Avec Faker (données plus réalistes)

**Faker** est une gem Ruby qui génère de fausses données réalistes (noms, titres, adresses, emails, dates, etc.) au lieu d'écrire `"Livre 1"`, `"Auteur 1"`... Très utile pour peupler une base de test avec des données qui ressemblent à de vraies données, sans les inventer à la main.

#### Installation

Dans le `Gemfile`, ajouter la gem (en général dans le groupe `:development, :test`) :

```ruby
group :development, :test do
  gem 'faker'
end
```

Puis installer :

```bash
bundle install
```

#### Générer 50 livres avec Faker

Dans `rails console` :

```ruby
50.times do
  Book.create(
    title: Faker::Book.title,
    author: Faker::Book.author,
    status: ["À lire", "En cours", "Lu"].sample
  )
end
```

#### Autres méthodes Faker utiles pour ce projet

```ruby
Faker::Book.title        # => "Le titre d'un livre inventé"
Faker::Book.author       # => "Nom d'auteur inventé"
Faker::Book.genre        # => genre littéraire (utile si tu ajoutes une colonne "genre")
Faker::Book.publisher    # => nom d'éditeur (utile si tu ajoutes une colonne "editeur")
Faker::Lorem.sentence    # => phrase aléatoire (utile pour un résumé/description)
Faker::Date.backward(days: 365) # => date aléatoire dans l'année passée (utile pour la date d'ajout)
```

#### Utiliser Faker dans un fichier `seed.rb`

Plutôt que de taper les commandes en console à chaque fois, on peut les centraliser dans `db/seeds.rb` :

```ruby
# db/seeds.rb
Book.destroy_all

50.times do
  Book.create(
    title: Faker::Book.title,
    author: Faker::Book.author,
    status: ["À lire", "En cours", "Lu"].sample
  )
end

puts "#{Book.count} livres créés ✅"
```

Puis exécuter :

```bash
rails db:seed
```

C'est la méthode recommandée en Rails pour peupler une base de données de façon répétable (à chaque `rails db:seed`, on repart d'une base propre avec 50 nouveaux livres).

### Résumé

| Action                    | Commande                      |
|----------------------------|--------------------------------|
| Supprimer tout              | `Book.delete_all`             |
| Supprimer proprement        | `Book.destroy_all`            |
| Générer 50 livres           | `50.times do ... end`         |
| Générer des vrais titres    | `Faker::Book.title` / `Faker::Book.author` |

---

## 1️⃣4️⃣ Recherche de livres

### Champ de recherche dans `index.html.erb`

```erb
<h1>Mes livres</h1>

<%= link_to "➕ Ajouter un livre", new_book_path %>

<br><br>

<%= form_with url: books_path, method: :get, local: true do %>
  <%= text_field_tag :query, params[:query], placeholder: "Rechercher un livre..." %>
  <%= submit_tag "Rechercher" %>
<% end %>

<br>
```

### Contrôleur — version simple

```ruby
def index
  if params[:query].present?
    @books = Book.where("title LIKE ? OR author LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
  else
    @books = Book.all
  end
end
```

⚠️ **Attention à bien fermer le `if` ET la méthode** avec deux `end` — c'est l'erreur la plus fréquente sur ce bloc.

### Contrôleur — recherche insensible à la casse

```ruby
def index
  if params[:query].present?
    query = "%#{params[:query].strip.downcase}%"
    @books = Book.where("LOWER(title) LIKE ? OR LOWER(author) LIKE ?", query, query)
  else
    @books = Book.all
  end
end
```

### Contrôleur — recherche multi-mots (mots dans n'importe quel ordre)

Utile pour que "tolkien seigneur" retrouve "Le Seigneur des Anneaux" de Tolkien, même si l'ordre est inversé :

```ruby
def index
  if params[:query].present?
    words = params[:query].strip.split(/\s+/)

    @books = Book.all
    words.each do |word|
      w = "%#{word.downcase}%"
      @books = @books.where("LOWER(title) LIKE ? OR LOWER(author) LIKE ?", w, w)
    end
  else
    @books = Book.all
  end
end
```

Chaque mot doit être présent (dans le titre OU l'auteur) : c'est une recherche cumulative.

### Message si aucun résultat

```erb
<% if @books.empty? %>
  <p>Aucun livre trouvé 😢</p>
<% end %>
```

### 🧠 Explications

- `params[:query]` = ce que l'utilisateur tape dans la barre de recherche
- `LIKE` = recherche SQL partielle (pas besoin d'écrire le mot entier)
- `%texte%` = contient le texte n'importe où dans la chaîne
- `LOWER(...)` = neutralise la casse (majuscules/minuscules)

⚠️ Avec **SQLite** (base par défaut en dev), `LIKE` est déjà insensible à la casse pour les caractères ASCII. Avec **PostgreSQL**, `LIKE` devient sensible à la casse : le `LOWER()` devient alors indispensable. Les accents (é, è, à...) ne sont gérés par aucune des deux approches nativement — il faudrait une gem type `unaccent` pour aller plus loin.

---

## 🚀 Prochaines améliorations possibles

- `enum` pour le statut (plus propre en Rails)
- validations (titre obligatoire)
- badges colorés (Lu / À lire / En cours)
- filtres par statut
- recherche instantanée (AJAX, sans reload)
- pagination
- fichier `seed.rb` propre pour les données de test
- design Bootstrap ou Tailwind
- petite API JSON
