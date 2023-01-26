### Zadanie 1 - przygotowanie repozytorium do laboratorium

Fork to swego rodzaju kopia innego repozytorium. Umożliwia on wprowadzanie zmian w projekcie do którego nie mamy praw zapisu, bez wpływu na oryginalne repozytorium - aczkolwiek możemy poprosić o uwzględnienie naszych zmian w oryginalnym repozytorium za pomocę pull requestów (merge requestów).

Fork repozytorium: https://github.com/miachal/iac-labs

### Zadanie 2 - uruchomienie projektu

#### Instalujemy zależności
```
iaac@14fbbee470d2:~/workspace$ sudo apt install git python3 python3-poetry
```

#### Kopiujemy repo, przechodzimy do example-app, odpalamy poetry żeby sprawdzić czy działa
```
iaac@14fbbee470d2:~/workspace$ git clone https://github.com/miachal/iac-labs
Cloning into 'iac-labs'...
remote: Enumerating objects: 258, done.
remote: Counting objects: 100% (10/10), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 258 (delta 2), reused 7 (delta 1), pack-reused 248
Receiving objects: 100% (258/258), 3.53 MiB | 4.05 MiB/s, done.
Resolving deltas: 100% (42/42), done.

iaac@14fbbee470d2:~/workspace$ cd iac-labs/example-app/

iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry debug info
Traceback (most recent call last):
  File "/usr/bin/poetry", line 5, in <module>
    from poetry.console import main
  File "/usr/lib/python3/dist-packages/poetry/console/__init__.py", line 1, in <module>
    from .application import Application
  File "/usr/lib/python3/dist-packages/poetry/console/application.py", line 7, in <module>
    from .commands.about import AboutCommand
  File "/usr/lib/python3/dist-packages/poetry/console/commands/__init__.py", line 4, in <module>
    from .check import CheckCommand
  File "/usr/lib/python3/dist-packages/poetry/console/commands/check.py", line 2, in <module>
    from poetry.factory import Factory
  File "/usr/lib/python3/dist-packages/poetry/factory.py", line 18, in <module>
    from .repositories.pypi_repository import PyPiRepository
  File "/usr/lib/python3/dist-packages/poetry/repositories/pypi_repository.py", line 11, in <module>
    from cachecontrol import CacheControl
ModuleNotFoundError: No module named 'cachecontrol'
```

#### Instalujemy moduł cachecontrol
```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ sudo apt install python3-cachecontrol
```

#### poetry debug info
```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry debug info

Poetry
Version: 1.1.12
Python:  3.10.6

Virtualenv
Python:         3.10.6
Implementation: CPython
Path:           NA

System
Platform: linux
OS:       posix
Python:   /usr
```

#### Instalujemy zależności projektowe

```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry install
...
• Installing mysqlclient (2.1.1): Failed
/bin/sh: 1: mysql_config: not found
        /bin/sh: 1: mariadb_config: not found
        /bin/sh: 1: mysql_config: not found
...
```

#### No to dorzucamy mysql-config

```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ sudo apt install libmysqlclient-dev
...

iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry install
...
• Installing psycopg2 (2.9.5): Failed
Error: pg_config executable not found.
```

#### Analogicznie robimy z postgresem
```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ sudo apt install libpq-dev
...

iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry install
Installing dependencies from lock file

No dependencies to install or update

  ValueError

  /home/iaac/workspace/iac-labs/example-app/example_app does not contain any element

  at /usr/lib/python3/dist-packages/poetry/core/masonry/utils/package_include.py:60 in check_elements
      56│         return any(element.suffix == ".py" for element in self.elements)
      57│ 
      58│     def check_elements(self):  # type: () -> PackageInclude
      59│         if not self._elements:
    → 60│             raise ValueError(
      61│                 "{} does not contain any element".format(self._base / self._include)
      62│             )
      63│ 
      64│         root = self._elements[0]
```

Something is no yes... ;)  
Patrzymy na ścieżkę: `/example-app/example_app`. Sounds weird.

```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry install --no-root
Installing dependencies from lock file

No dependencies to install or update
```

#### Odpalamy!

```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry run task server
 * Serving Flask app 'apps' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
```

albo i nie :)

```
127.0.0.1 - - [28/Nov/2022 13:25:40] "GET / HTTP/1.1" 500 -
Error on request:
Traceback (most recent call last):
...
    conn = _connect(dsn, connection_factory=connection_factory, **kwasync)
psycopg2.OperationalError: connection to server at "localhost" (127.0.0.1), port 3306 failed: Connection refused
	Is the server running on that host and accepting TCP/IP connections?
connection to server at "localhost" (::1), port 3306 failed: Cannot assign requested address
	Is the server running on that host and accepting TCP/IP connections?
```

No to zorganizujmy sobie jakąś bazę danych, ja w tym celu wspomogłem się azurem.  
Edytujemy `env.sample` i zapisujemy jako `.env`

```
...
DB_ENGINE=mysql
DB_NAME=iaac-lab01
DB_HOST=wsb-iaac-mysql.mysql.database.azure.com
DB_PORT=3306
DB_USERNAME=iaacUser
DB_PASS=Dupa123

```

Startujemy
```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry run task server
 * Serving Flask app 'apps' (lazy loading)
 * Environment: development
 * Debug mode: on
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
 * Restarting with stat
[2022-11-28 13:54:09,956] INFO in run: DEBUG            = True
[2022-11-28 13:54:09,956] INFO in run: Page Compression = FALSE
[2022-11-28 13:54:09,956] INFO in run: DBMS             = sqlite:////home/iaac/workspace/iac-labs/example-app/apps/db.sqlite3
[2022-11-28 13:54:09,957] INFO in run: ASSETS_ROOT      = /static/assets
 * Debugger is active!
 * Debugger PIN: 611-725-748
```

I sprawdzamy czy działa

```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ links http://localhost:5000
```
![img/01.png](img/01.png)

```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ fg %1
poetry run task server
127.0.0.1 - - [28/Nov/2022 14:06:01] "POST /login HTTP/1.1" 200 -
127.0.0.1 - - [28/Nov/2022 14:06:01] "POST /login HTTP/1.1" 200 -
127.0.0.1 - - [28/Nov/2022 14:06:01] "GET /register HTTP/1.1" 200 -
```

Looks good. Teraz zastanawiamy się po co była ta baza mysqlowa, skoro i tak korzystamy z sqlite... :)  
Prawdopodobnie wcześniejsze utworzenie pliku `.env` zaoszczędziłoby nam zachodu.  

Doczytujemy komentarze w pliku `.env` i zauważamy, że jeśli `DEBUG=False` to wtedy faktycznie użyjemy wersji produkcyjnej razem z naszą bazą.

#### Czy projekt się uruchomił? Wnioski?

Tak, projekt się uruchomił, natomiast proces instalacji niezbędnych zależności był długi i uciążliwy, w zależności od środowiska na którym zechcemy uruchomić projekt prawdopodobnie będziemy mierzyć się z ciut innymi rozwiązaniami.

Powyższy proces przeprowadzany był na Ubuntu 22.04.

#### Pozostałe możliwe zadania do uruchomienia

```
[tool.taskipy.tasks]
lint = "pylint apps"
formatter = "black --check apps"
security = "bandit -r apps"
test = "pytest tests/"
server = "poetry run python run.py"
```

```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry run task lint

--------------------------------------------------------------------
Your code has been rated at 10.00/10
```
```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry run task formatter
All done! ✨ 🍰 ✨
9 files would be left unchanged.
```
```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry run task security
[main]	INFO	profile include tests: None
[main]	INFO	profile exclude tests: None
[main]	INFO	cli include tests: None
[main]	INFO	cli exclude tests: None
[main]	INFO	running on Python 3.10.6
Run started:2022-11-28 14:23:51.433347

Test results:
	No issues identified.

Code scanned:
	Total lines of code: 245
	Total lines skipped (#nosec): 0

Run metrics:
	Total issues (by severity):
		Undefined: 0
		Low: 0
		Medium: 0
		High: 0
	Total issues (by confidence):
		Undefined: 0
		Low: 0
		Medium: 0
		High: 0
Files skipped (0):
```
```
iaac@14fbbee470d2:~/workspace/iac-labs/example-app$ poetry run task test
================================================================================================= test session starts =================================================================================================
platform linux -- Python 3.10.6, pytest-7.2.0, pluggy-1.0.0
rootdir: /home/iaac/workspace/iac-labs/example-app
collected 1 item                                                                                                                                                                                                      

tests/test_true.py .                                                                                                                                                                                            [100%]

================================================================================================== 1 passed in 0.00s ==================================================================================================
```

### Zadanie 3 - Tworzenie środowiska ciągłej integracji

#### W jakim katalogu github sugeruje tworzenie konfiguracji do uruchamiania CI/CD?

.github/workflows

#### Czy jest to ta sama metoda instalowania zależności?

Nie, w poprzednim zadaniu instalowaliśmy zależności przy pomocy poetry i virtualenvów,  
w templatce używamy natomiast `pip install -r requirements.txt` i instalujemy wszystko w jednej przestrzeni.

#### Python application template

https://github.com/miachal/iac-labs/actions/runs/3565833560/jobs/5991494452

#### Poetry Action

https://github.com/miachal/iac-labs/actions/runs/3565889059/jobs/5991624893

#### Modyfikujemy wf tak, aby korzystał faktycznie z poetry

```
jobs:
  build:

    runs-on: ubuntu-latest
    
    defaults:
      run:
        working-directory: ./example-app

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python 3.10
      uses: actions/setup-python@v3
      with:
        python-version: "3.10"
        
    - name: Install Poetry Action
      uses: snok/install-poetry@v1.3.3
      
    - name: Install dependencies
      run: poetry install --no-root
        
    - name: Lint with flake8
      run: poetry run task lint
        
    - name: Test with pytest
      run: poetry run task test
```

https://github.com/miachal/iac-labs/actions/runs/3565930296/jobs/5991724677

![img/02.png](img/02.png)

#### Ile czasu github-actions runnera sumarycznie zużyłeś podczas tworzenia środowiska CI?

Settings -> Access -> Billing and plans

![img/03.png](img/03.png)

Możliwe, że github dopiero po jakimś czasie zaktualizuje te informacje. 

Zużycie można sprawdzić również z poziomu konkretnego wf:  
https://github.com/miachal/iac-labs/actions/runs/3565930296/usage  
Run time: 1m 53s  
Billable time: 0s

#### Jaki jest limit miesięczny minut przydzielony w planie darmowym dla developera?

https://docs.github.com/en/actions/learn-github-actions/usage-limits-billing-and-administration#usage-limits

Job execution time: up to 6h  
Wf run time: 35d  
Total concurrent jobs: 20  

### Zadanie 4 - tworzenie matrycy/ciagów zadań ciągłej integracji

https://github.com/miachal/iac-labs/blob/ddf2c18c02a0749131ea5a937e4edcf866cbf4ba/.github/workflows/python-app.yml

#### Wydzielamy osobne joby

Zarówno lint jak i tests powinno być zależne od build.

```
jobs:
  build:
    ...

  lint:
    needs: build
    ...

  tests:
    needs: build
    ...
```

#### Instalujemy poetry

```
# build
    - name: Install Poetry Action
      uses: snok/install-poetry@v1.3.3
      with:
        version: 1.1.12
        virtualenvs-create: true
        virtualenvs-in-project: true
```

Określamy wersję poetry na taką jak mieliśmy lokalnie (aby uniknąć rozbieżności z tego tytułu).  
W procesie budowania powinien zostać utworzony virtualenv i zaznaczamy, że chcemy utworzyć go w projekcie
(dzięki temu będzie dostępny pod .venv w katalogu projektu).  
  
W jobach lint i tests powielamy wpis z tą różnicą, że nie chcemy już tworzyć venva (chcemy wykorzystać ten, który został utworzony na etapie budowania).

#### Cache

```
      - name: Handle cache
        id: cached-venv
        uses: actions/cache@v3
        with:
          path: |
            ~/.local
            ${{ github.workspace }}/example-app/.venv
          key: ${{ runner.os }}-venv
```

Między jobami chcemy przepchąć dwie rzeczy.  
Pierwszą jest katalog dla poetry, aby zamiast instalować je jeszcze raz skorzystać z istniejącego już.  
Drugą jest virtualenv wytworzony przez poetry.

#### Lint, formatter, security, tests

Jako, że mamy teraz virtualenva z poprzedniego joba pod `${{ github.workspace }}/example-app/.venv`, a znajdujemy
się w `example-app` (bo tak został określony working-directory) to możemy zawołać
`source .venv/bin/activate`, aby aktywować venva.  
  
Z racji tego, że mamy już enva `VENV=.venv/bin/activate` to możemy jeszcze trochę skrócić zapis.


```
      - name: Lint
        run: |
          source $VENV
          poetry run task lint
```

Analogicznie dla reszty tasków.

#### Jaka jest różnica między `job`, a `step`?

Stepy są wykonywane sekwencyjnie w obrębie jednego runnera.  
W przypadku jobów mamy do czynienia z osobnym runnerami, joby mogą być wykonywane równolegle.

#### Dlaczego wykorzystujemy mechanizm `cache` zamiast duplikować cały kod?

Aby przyśpieszyć cały proces - zamiast instalować w kółko te same zależności robimy to tylko raz i kopiujemy między runnerami.

### Zadanie 5 - Testowanie różnych systemów operacyjnych

Dodajemy do jobów:
```
   strategy:
      matrix:
        os: [ubuntu-latest, windows-latest]
    runs-on: ${{ matrix.os }}
```

Przy buildzie dla windowsa dostajemy
```
 The term 'poetry' is not recognized as a name of a cmdlet, function, script file, or executable program. Check
     | the spelling of the name, or if a path was included, verify that the path is correct and try again.
```

Patrzymy na step z instalacją poetry i widzimy, że musimy dodać ścieżkę do PATHa.
```
To get started you need Poetry's bin directory (C:\Users\runneradmin\.local\bin) in your `PATH`
environment variable.
```

Dodajemy step, który doda nam katalog z poetry do patha i wykona się tylko na windowsie.
```
    - name: Add poetry to PATH
      if: matrix.os == 'windows-latest'
      run: Add-Content $env:GITHUB_PATH "C:\Users\runneradmin\.local\bin"
```

i wygląda na to, że build pod windowsem przechodzi.  

Problem pojawia się na etapie cachowania poetry
```
The latest version (1.1.12) is already installed.
D:\a\_actions\snok\install-poetry\v1.3.3/main.sh: line 36: /c/Users/runneradmin/.local/bin/poetry: No such file or directory
```

całkiem możliwe, że akcja snoka nie jest przystosowana pod taki target.  
Rozwiązaniem okazuje się rezygnacja z cachowania poetry.

Kolejnym problemem był fakt, że domyślną powłoką pod windowsem jest powershell i zapis w stylu `source $VENV` nie jest poprawny.  
Zmieniamy powłokę na basha i jest zielono.

![img/04.png](img/04.png)

Konfiguracja:  
https://github.com/miachal/iac-labs/blob/64761afaa38a845bb5161f4bf8eec36bad913866/.github/workflows/python-app.yml

#### Po co to wszystko?

Aby przetestować projekt z różnymi wariantami systemów, bibliotek czy innych zmiennych.

#### Koszty

![img/05.png](img/05.png)


### Zadanie 6 - Wdrażanie kodu w sposób ciągły (CD)

New -> Blueprint

![img/06.png](img/06.png)

Deploy się powiódł, natomiast w logach widzimy problem z bazą danych - coś co widzieliśmy wcześniej,
należy dodać ustawienia połączeniowe dla aplikacji.  
  
Tworzymy bazę PG (New -> PostgreSQL), uzupełniamy env i wrzucamy w secrets na render.com.

```
DB_ENGINE=postgres
DB_HOST=
DB_NAME=
DB_PORT=5432
DB_USERNAME=
DB_PASS=
```

![img/07.png](img/07.png)

Robimy redeploy (Clear build cache & Deploy).  
Pod adresem https://flask-poetry-uud7.onrender.com dostępna jest nasza aplikacja.

![img/08.png](img/08.png)


#### Czy modyfikacje github actions są potrzebne, by uzyskać ciągłe wdrażanie w tym przypadku?

Zrobiliśmy tylko ręczny deploy, aby uzyskać ciągłe wdrażanie wypadałoby co build robić deploy, np.
trykając udostępnionego przez render hooka.  