using DataFrames, CSV, XLSX

function grades_2020()
    name = ["Sally", "Bob", "Alice", "Hank"]
    grade_2020 = [1, 5, 8.5, 4]
    DataFrame(; name, grade_2020)
end

function write_grades_CSV()
   path = "grades.csv" 
   CSV.write(path, grades_2020())
end

path = write_grades_CSV()
read(path, String)

function grades_with_comma()
    df = grades_2020()
    df[3, :name] = "Alice,"
    df
end

#=
Use CSV.read and specify kind of format (DataFrame)
=# 

path = write_grades_CSV()
df = CSV.read(path, DataFrame)

my_data = """
            a, b, c, d, e
            Kim, 2018-02-03, 3, 4.0, 2018-02-03T10:00
        """
path = "my_data.csv"
write(path, my_data)

df = CSV.read(path, DataFrame)

#=
Excel Package XLSX
=#

function write_xlsx(name, df::DataFrame) # helper function
   path = "$name.xlsx" 
   data = collect(eachcol(df)) # returns column data as vectors
   cols = names(df) # return column names as vectors
   XLSX.writetable(path, data, cols)
end

function write_grades_xlsx()
    path = "grades"
    write_xlsx(path, grades_2020())
    "$path.xlsx"
end

path = write_grades_xlsx()
xf = XLSX.readxlsx(path)

xf = XLSX.readxlsx(write_grades_xlsx())
sheet = xf["Sheet1"]
XLSX.eachtablerow(sheet) |> DataFrame

# Indexing

function names_grades1()
    df = grades_2020()
    df.name # return name as a vector 
end

names_grades1()


function names_grades2()
    df = grades_2020()
    df[!, :name] # ! in-place modification
end

names_grades2()


function grade_2020(i::Int)
    df = grades_2020()
    df[i, :]
end

grade_2020(2)


grades_indexing(df::DataFrame) = df[1:2, :name]
grades_indexing(grades_2020())

function grade_2020(name::String)
    df = grades_2020()
    dic = Dict(zip(df.name, df.grade_2020))
    dic[name]
end

grade_2020("Bob")

# Filter function
equals_alice(name::String) = name == "Alice"
equals_alice("Bob")

filter(:name => equals_alice, grades_2020())
filter(equals_alice, ["Alice", "Bob", "James"]) # besides DataFrame, also works with vectors

filter(n -> n == "Alice", ["Alice", "Bob", "James"]) # annonymous function more concise

filter(:name => n -> n == "Alice", grades_2020())
filter(:name => ==("Alice"), grades_2020()) # even more concise; note no space after ==
filter(:name => !=("Alice"), grades_2020())

function complex_filter(name, grade)::Bool
    interesting_name = startswith(name, 'A') || startswith(name, 'B')
    interesting_grade = grade > 4
    interesting_name && interesting_grade
end

filter([:name, :grade_2020] => complex_filter, grades_2020())