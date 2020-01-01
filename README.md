# The Coin

This repository is to break the encryption of the message:

```
Vm gp vdqvzh ljjmuwaxc yfw lipxbh li qc zrukvauo xikhxoljkhuhk, du zzzyc li vgvvdjjx dsz wuqvboi kopjttdtgh.
```

## Vigenère Cipher

The first attempt was a simple rot encryption, then a Vigenère.

```ruby
load './vigenere.rb'
client = Vigenere.new('erudite')
encrypted = client.encrypt([13, 2, 22, 4]) #=> "rpyzvri"
client = Vigenere.new(encrypted)
decrypted = client.decrypt([13, 2, 22, 4])
```

These didn't yield much that looked correct so I moved on to brute force

## Breaker

The `breaker.rb` is an attempt to use the Vigenère Scheme to brute force the message. It's configured to accept whatever scheme you like. However, I suspect it may only work correctly with Vigenère. Iterating over all the permuations within four letters, we collect every possible deciphered text and compare it to a dictionary of words. If there is a small set of words that match, we list them as possible keys used for the enciphered text.

```ruby
load './vigenere.rb'
load './breaker.rb'
client = Vigenere.new('njczrlm')
breaker = Breaker.new(client)
breaker.run
```

```
Brute force breaking: njczrlm
Comparing all 4 keyed polyalphabetic encryptions of njczrlm to 234371 words
Checking 1 range:
26 words
Matches Found: 0
Checking 2 range:
676 words
Matches Found: 0
Checking 3 range:
17576 words
Matches Found: 0
Checking 4 range:
456976 words
Matches Found: 1
[17, 8, 18, 4] erudite
```

Here we were able to break the cipher without knowing the keyword. The breaker takes a few seconds at four letters, but beyond that it takes several minutes.

## Porta Cipher

I was then informed that the cipher used was a Porta Filter. Here's the usage:

```ruby
load './porta.rb'
message = 'defendtheeastwallofthecastle'
scheme = Porta.new('defendtheeastwallofthecastle')

message = 'doanotherthingforthecastle'
scheme = Porta.new(message)
result = scheme.encrypt('fortification')
scheme = Porta.new(result)
scheme.decrypt('fortification')
```

Using this, we'll try breaking the message

```ruby
load './porta.rb'
message = "Vm gp vdqvzh ljjmuwaxc yfw lipxbh li qc zrukvauo xikhxoljkhuhk du zzzyc li vgvvdjjx dsz wuqvboi kopjttdtgh"
scheme = Porta.new(message)
scheme.decrypt('love')
#=> "dtqadxgghovyotkhsdzjxcvxkdywqpgrhkkzdukmfpuwfhvypokwpxkkhfbrqplvdbnyodndhckbdvexphfybmneyo"
```

This isn't right. It could be due to the key we're providing. Let's adapt breaker to make use of the `Porta` scheme. Making the Porta scheme accept an array of characters instead of a word. Let's test the breaker with a previous message, with a smaller key of course:

```ruby
load './porta.rb'
message = 'defend'
scheme = Porta.new(message)
result = scheme.encrypt('fort')
#=> "synnlx"

load './breaker.rb'
client = Porta.new(result)
breaker = Breaker.new(client)
breaker.run
```

```
Brute force breaking: synnlx
Comparing all 4 keyed polyalphabetic encryptions of synnlx to 234371 words
Checking 1 range:
13 words
Matches Found: 0
Checking 2 range:
169 words
Matches Found: 0
Checking 3 range:
2197 words
Matches Found: 0
Checking 4 range:
28561 words
Matches Found: 5
[5, 15, 3, 1] demand
[5, 15, 17, 19] defend
[5, 15, 25, 11] debind
[7, 9, 19, 25] chebog
[15, 23, 7, 11] lakism
```

Let's use this with one of the words from the original message to check if we've got the wrong key:

```ruby
load './porta.rb'
load './breaker.rb'
client = Porta.new("xikhxoljkhuhk")
breaker = Breaker.new(client)
breaker.run
```

Here we have:

```
Checking 1 range:
13 words
Matches Found: 0
Checking 2 range:
169 words
Matches Found: 0
Checking 3 range:
2197 words
Matches Found: 0
Checking 4 range:
28561 words
Matches Found: 1
[17, 13, 7, 23] consciousness
```

Seems promising, let's convert those indexed into a key word ("comes out to `rnhx` for some reason"), and then use it to break the entire message:

```ruby
message = "Vm gp vdqvzh ljjmuwaxc yfw lipxbh li qc zrukvauo xikhxoljkhuhk du zzzyc li vgvvdjjx dsz wuqvboi kopjttdtgh"
client = Porta.new(message)
client.decrypt('rnhx')
```

This worked correctly. Downloading this code and running it will give you the response.

## Result

I was told the key word was `love`. It seems the source of the tableau I was using was different than the one used when the cipher was created. I took the one [from the ACA](https://www.cryptogram.org/downloads/aca.info/ciphers/Porta.pdf), but it seems there are some other slightly different tableaus you can find on the internet. Fun project!
