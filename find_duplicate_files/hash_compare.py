#! /usr/bin/env python
'''
hash_compare.py
This script takes in an indeterminate number of CSVs containing MD5 hash codes as well as file info and
concatenates them into one pandas dataframe.  This dataframe is boolean-indexed to return only duplicate
hashes, sorted by hash and size, and then written out to the current directory.
'''
import sys
import pandas as pd

def find_duplicates(csvs):
    '''
    A function that concatenates all the CSVs into one dataframe, finds duplicate hash values,
    and then returns a sorted dataframe with only the duplicated values.
    Arguments:
        csvs (list) - A list of paths to hash csv files to open.  Assumes that column labels
        are the same across CSVs.
    '''
    df = pd.DataFrame()
    # Concatenate all the CSVs together.  df = pd.DataFrame()
    for csv in csvs:
        print csv
        csv_df = pd.read_csv(csv, low_memory=False,error_bad_lines=False)
        df = pd.concat([df, csv_df])
    df['size'] = pd.to_numeric(df['size'],errors='coerce')
    return df[df.duplicated(subset=['hash'], keep = False)].sort_values(by=['size','hash'],ascending=[False,True],kind='mergesort')

if __name__ == '__main__':
    csvs = sys.argv[1:]
    duplicates_df = find_duplicates(csvs)
    for user in duplicates_df.owner.unique():
        user_duplicates = duplicates_df[duplicates_df.owner == user]
        user_duplicates = pd.merge(user_duplicates,duplicates_df,how='left',on = ['hash']).sort_values(by=['size','hash'],ascending=[False,True],kind='mergesort')
        user_duplicates.to_csv('file_duplicates_%s.csv' % user ,index=False)
    
