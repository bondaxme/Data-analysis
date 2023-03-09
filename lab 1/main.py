import csv
from datetime import datetime


def format_date():
    with open('matches.csv', 'r') as csvfile:
        reader = csv.DictReader(csvfile)

        with open('updated_matches.csv', 'w', newline='') as outfile:
            fieldnames = reader.fieldnames
            writer = csv.DictWriter(outfile, fieldnames=fieldnames)
            writer.writeheader()

            for row in reader:
                date_str = row['date_time']
                date = datetime.strptime(date_str, '%d-%b-%y %I.%M.%S.%f000000 PM')
                updated_date_str = date.strftime('%Y-%m-%d %H:%M:%S')
                row['date_time'] = updated_date_str
                old_value = row['match_id']
                new_value = old_value[2:]
                row['match_id'] = new_value
                writer.writerow(row)

def format_date_managers():
    with open('managers.csv', 'r') as csvfile:
        reader = csv.DictReader(csvfile)

        with open('updated_managers.csv', 'w', newline='') as outfile:
            fieldnames = reader.fieldnames
            writer = csv.DictWriter(outfile, fieldnames=fieldnames)
            writer.writeheader()

            for row in reader:
                date_str = row['date_of_birth']
                date = datetime.strptime(date_str, '%m-%d-%Y')
                updated_date_str = date.strftime('%Y-%m-%d')
                row['date_of_birth'] = updated_date_str
                writer.writerow(row)

format_date_managers()



