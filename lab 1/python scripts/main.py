from funcs import *

if __name__ == "__main__":
    format_date('date_of_birth', 'managers.csv', 'updated_managers.csv', '%m-%d-%Y', 0)
    format_date('date_time', 'matches.csv', 'updated_matches.csv', '%d-%b-%y %I.%M.%S.%f000000 PM', 1)
    format_stadiums_names('updated_matches.csv')


