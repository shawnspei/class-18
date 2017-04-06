
PLACES = ["universe",
          "colorado",
          "123", "any_new_name"]

print(expand("hello_{place}.txt", place = PLACES))

rule all:
    input:
        expand("hello_{place}.txt", place = PLACES)

rule hello_universe:
    input: "hello_world.txt"
    output: "hello_{place}.txt"
    shell:
      " sed 's/world/{wildcards.place}/' {input} > {output} "

rule hello_world:
    input: "world.txt"
    output: "hello_world.txt"
    shell:
      " echo 'Hello' | cat - {input} > {output} "
