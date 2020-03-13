def make_cnt(s, printTbl, alphabet=None):
    # Create alphabet (aka. used characters) if none is provided
    if alphabet is None:
        alphabet = set(s);
        
    # Count each character repetetions
    c = cnter(s);
    
    # Sort the alphabet and
    # Get the position where the next character starts
    total = 0;
    result = {};
    for letter in sorted(alphabet):
        result[letter] = total;
        total += c[letter];
        
    # Print the result
    if printTbl: print("Character score:\n", result, "\n");
    return result;

def make_suffixArray(s, printTbl):
    # Iterate s and generate all suffixes
    suffixes = {};
    for i in range(len(s)):
        suffixes.update({s[i:] : i});
    
    # Sort suffixes by name
    lst_sort = sorted(suffixes.keys());

    # Iterate suffix and get their index
    lst = list(suffixes[suffix] for suffix in lst_sort);
    
    # Print the list of sorted suffixes
    if printTbl: print("Suffixes:\n", lst_sort, "\n");
        
    # Return the list of indexes
    return lst;

def make_bwt(s, printTbl, suffixArray=None):
    # Create an suffix array if none is provided
    if suffixArray is None:
        suffixArray = make_suffixArray(s, printTbl);
        
    # Compute the Burrows-Wheeler Transform
    bwt = '';
    for idx in suffixArray:
        bwt = bwt + s[idx - 1]; # -1 as the last character is EOS
    
    # Print the the Burrows-Wheeler Transform
    if printTbl:
        print("iBWT:\n", s, "\n");
        print("BWT:\n", bwt, "\n");
    return bwt;

def make_occ(bwt, printTbl, letters=None):
    # Create a list with the used characters
    if letters is None:
        letters = set(bwt);
    
    # Create a dict including each character with counts eq to zero
    result = {};
    for letter in letters:
        result.update({letter : [0]});
    
    # Initialize the counter with 1 for the 1st character
    result[bwt[0]] = [1];
    # for each charter in the BWT,
    for letter in bwt[1:]:
        # Add a column to the right, counting the appearances of each character
        for k, v in result.items():
            v.append(v[-1] + (k == letter));
            
    # Print the occurrences of each character
    if printTbl: print("BWT Occurrence:\n", result, "\n");
    return result;

def make_all(sequence, printTbl, suffixArray=None, eos=EOS):
    # Create a list with the used characters
    alphabet = set(sequence);
    
    # Ensure EOS is not a character within the sequence
    assert eos not in alphabet;
    
    # Get the count of the characters in the sequence
    cnt = make_cnt(sequence, printTbl, alphabet);
    
    # Concatenate EOS to the sequence
    sequence = sequence + eos;
    
    # Create an suffix array if none is provided
    if suffixArray is None:
        suffixArray = make_suffixArray(sequence, printTbl);
        
    # Compute the Burrows-Wheeler Transform
    bwt = make_bwt(sequence, printTbl, suffixArray);
    
    # Get the occurrences of each character
    letters = alphabet | set([eos])
    occ = make_occ(bwt, printTbl, letters);
    
    # Make sure the indexes never exceed the sequence limits
    for k, v in occ.items():
        v.extend([v[-1], 0]);
    
    # Print/Return all tables
    if printTbl: print("alphabet:\n", alphabet, "\n");
    return alphabet, bwt, occ, cnt, suffixArray;

def update_range(begin, end, letter, occ, cnt, length):
    # Set the new left pointer
    newbegin = cnt[letter] + occ[letter][begin - 1] + 1;
    
    # Set the new left pointer
    newend = cnt[letter] + occ[letter][end];
    
    # Return the range limits
    return newbegin, newend;

def find(query, sequence, printTbl=False, mismatches=0, bwt_data=None, suffixArray=None):
    # Ensure the query to search is long enough
    assert len(query) > 0;
    
    # Save the query string for later use
    query_str = query;
    
    # Create all the required tables
    if bwt_data is None:
        bwt_data = make_all(sequence, printTbl, suffixArray=suffixArray);
    alphabet, bwt, occ, cnt, suffixArray = bwt_data;
    
    # Ensure the alphabet contains at least one character
    assert len(alphabet) > 0;
    
    # If the query contains more characters than the alphabet,
    # then there are not matches
    if not set(query) <= alphabet:
        return [];
    
    # Define a 'stack' data structure
    class Partial(object):
        def __init__(self, **kwargs):
            self.__dict__.update(kwargs);
    
    # Create a 'stack' of partial matches
    length = len(bwt);
    results = [];
    partial_matches = [Partial(
        query      = query,
        begin      = 0,
        end        = len(bwt) - 1,
        mismatches = mismatches
    )];
    
    # Iterate the query (character by character) to find matches
    while len(partial_matches) > 0:
        # Read and remove an element of partial_matches
        p = partial_matches.pop();
        
        # Search for the query (letter by letter)
        query = p.query[:-1];        
        last = p.query[-1];
        
        # If mismatches are allowed, then use the whole alphabet
        # If no mismatches are allowed, only use the current character/letter
        if p.mismatches == 0: letters = [last];
        else:                 letters = alphabet;
        
        # Check if the current letter is a match 
        for letter in letters:
            # Get the range where the current character appears
            begin, end = update_range(p.begin, p.end, letter, occ, cnt, length);
            
            # Iterate the calculated range/window
            if begin <= end:
                # Stop comparing if the current letter is last character of the query
                # Store the match location in results
                if len(query) == 0:
                    results.extend(suffixArray[begin : end + 1]);
                else:
                    # Track the number of mismatches
                    mismatchesCnt = p.mismatches;
                    
                    # Decrement the number of allowed mismatches if one is founded
                    if letter != last:
                        mismatchesCnt = max(0, p.mismatches - 1);
                    
                    # Update the 'stack'
                    partial_matches.append(Partial(
                        query      = query,
                        begin      = begin,
                        end        = end,
                        mismatches = mismatchesCnt
                    ));
                    
    # Sort the match locations
    res = sorted(set(results));
    
    # Print and Return the result
    print("subSequence appears at possitions:\n", res);
    print('', sequence);
    for i in res: print(' '*i,query_str);
    print();
    return res;

find('ana', 'banana', printTbl=True);