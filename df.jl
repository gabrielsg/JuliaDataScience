using Dates, DataFrames, CSV, XLSX, OhMyREPL

function grades_2020()
   name = ["Sally", "Bob", "Alice", "Hank"]
   grade_2020 = [1, 5, 8.5, 4]
   DataFrame(; name, grade_2020)
end

function write_grades_csv()
  path = "grades.csv" 
  CSV.write(path, grades_2020())
end

path = write_grades_csv()
read(path, String)

function grades_with_comma()
   df = grades_2020()
   df[3, :name] = "Alice,"
   df
end

#=
Use CSV.read and specify kind of format (DataFrame)
=# 

path = write_grades_csv()
df = CSV.read(path, DataFrame)

my_data = """
            a, b, c, d, e
            Kim, 2018-02-03, 3, 4.0, 2018-02-03T10:00
        """
path = "my_data.csv"
write(path, my_data)

df = CSV.read(path, DataFrame)

#=
#Excel Package XLSX
=#

function write_xlsx(name, df::DataFrame) # helper function
  path = "$name.xlsx" 
  data = collect(eachcol(df)) # returns column data as vectors
  cols = names(df) # return column names as vectors
  XLSX.writetable(path, data, cols, overwrite=true)
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

## Indexing

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

## Filter function
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

#= Subset
Added to make easier to work with missing data
In contrast to filter, subset works on complete columns instead
of rows or single values. If we want to use our earlier defined functions, we
should wrap it inside ByRow:
=#

subset(grades_2020(), :name => ByRow(equals_alice)) # Note that DataFrame is now the first argument subset (df, args..) and filter (f, df)
subset(grades_2020(), :name => ByRow(name -> name == "Alice")) #annonymous function
subset(grades_2020(), :name => ByRow(==("Alice"))) #partial function

function salaries()
    names = ["John", "Hank", "Karen", "Zed"]
    salary = [1_900, 2_800, 2_800, missing]
    DataFrame(; names, salary)
end

# filter(:salary => >(2000), salaries()) # filter will fail because it doesn't know how to handle missing data

# subset(salaries(), :salary => ByRow(>(2000))) # will also fail but provides hints what to do next
subset(salaries(), :salary => ByRow(>(2000)), skipmissing=true )

#=
Whereas filter removes rows, select removes columns. However, select is
much more versatile than just removing columns
=#

function responses()
    id = [1, 2]
    q1 = [28, 61]
    q2 = [:us, :fr]
    q3 = ["F", "B"]
    q4 = ["B", "C"]
    q5 = ["A", "E"]
    DataFrame(; id, q1, q2, q3, q4, q5)
end

responses()

select(responses(), :id, :q1)
select(responses(), Not(:q5))
select(responses(), :q4, Not(:id))
select(responses(), 3, :) # start with column 3 and then the rest of the columns

#=
Few ways to select columns :
Symbol : select(df, :col)
String : select(df, "col")
Integer : select(df, 1)

Rename columns via select through the source => target pair syntax
=#

select(responses(), 1 => "participant", :q1 => "age", :q2 => "nationality")
renames = (1 => "participant", :q1 => "age", :q2 => "nationality")
select(responses(), renames...) # using the splat operator ...

#=
Types and Missing data
=#

function wrong_types()
    id = 1:4
    date = ["28-01-2018", "03-04-2019", "01-08-2018", "22-11-2020"]
    age = ["adolescent", "adult", "infant", "adult"]
    DataFrame(; id, date, age)
end

wrong_types()

#sort(wrong_types(), :date) # doesn't work correctly as date is the wrong type

function fix_date_column(df)
    string2dates(dates::Vector) = Date.(dates, DateFormat("dd-mm-yyyy"))
    dates = string2dates(df[!, :date])
    df[!, :date] = dates
    df
end

fix_date_column(wrong_types())

using CategoricalArrays

function fix_age_column(df)
    levels = ["infant", "adolescent", "adult"]
    ages = categorical(df[!, :age], levels=levels, ordered=true)
    df[!, :age] = ages
    df
end

fix_age_column(wrong_types())

## Join
function grades_2021()
    name = ["Bob 2", "Sally", "Hank"]
    grade_2021 = [9.5, 9.5, 6.0]
    DataFrame(; name, grade_2021)
end

grades_2021()

innerjoin(grades_2020(), grades_2021(), on=:name)
outerjoin(grades_2020(), grades_2021(), on=:name) # less strict than innerjoin and will take any row it can find with name in at least one of the dataset

#Cartesian product of the rows, which is basically multiplication of rows, that is, for every row create a combination with any other row
# makeunique=true needed because same column name, :name, in both df
crossjoin(grades_2020(), grades_2021(), makeunique=true) 

leftjoin(grades_2020(), grades_2021(), on=:name) # The left join gives all the elements in the left DataFrame
rightjoin(grades_2020(), grades_2021(), on=:name)
#=
Note that leftjoin(A, B) != rightjoin(B, A), because the order of the columns
will differ.
=#


#=
Transformation : how to transform variables, that is, how to modify
data. In DataFrames.jl, the syntax is source => transformation => target.
=#
plus_one(grade) = grade .+ 1
transform(grades_2020(), :grade_2020 => plus_one => :grades_2020_revised)

leftjoined = leftjoin(grades_2020(), grades_2021(); on=:name)
pass(A, B) = [5.5 < a || 5.5 < b for (a, b) in zip(A, B)]
transform(leftjoined, [:grade_2020, :grade_2021] => pass; renamecols=false)




