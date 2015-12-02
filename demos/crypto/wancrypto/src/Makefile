
LIB =
CFLAGS_ALL = -c -O2 -Wall $(CFLAGS) -I ../include/ -I ../wancrypto/include/ -DDEBUG
RM = rm

OBJS = \
  wancrypto_aes.o \
  wancrypto_picture.o

all: $(LIBS)

$(LIBS): $(OBJS)
	ar crv $(LIBS) $(OBJS)
	mv $(LIBS) $(DEST)
	$(RM) -f $(OBJS)
	
wancrypto_aes.o: wancrypto_aes.c
	$(CC) $(CFLAGS_ALL) $^

wancrypto_picture.o: wancrypto_picture.c
	$(CC) $(CFLAGS_ALL) $^

clean:
	$(RM) $(OBJS)
