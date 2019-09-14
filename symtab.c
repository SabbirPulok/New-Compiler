#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

int declare = 0;
static list_t* head = NULL;

int address=0;

void insert(char *name, int len, int type)
{
    list_t* ptr = (list_t*)malloc(sizeof(list_t));
    strncpy(ptr->st_name, name, len); 
    ptr->st_type = type;
    ptr->next = head;
    ptr->address = address;
    address++;

    printf("inserting %s in symtab and its address = %d\n", ptr->st_name, ptr->address);

    head = ptr;
}

// int int_val_insert(int val, char *name)
// {
//     list_t* ptr;
//     int add=search(*name);
//     ptr->int_val = val;
//     ptr->address=add;
//     // ptr->next = head;
//     // ptr->address = address;
//     // address++;
//     printf("inserting %d in symtab and its address = %d\n", ptr->int_val, ptr->address);

//     head=ptr;
//     // head = ptr;
// }

list_t* search(char *name) 
{ 
    list_t *current = head;  // Initialize current 
    while (current != NULL) 
    { 
        if (strcmp(name,current->st_name) != 0)
        {
            current = current->next; 
        }
        else
        {
            break;
        }
    } 
    return current; 
} 

void symtab_data()
{
    printf("-----------Sym Table------------\n");
    list_t *current = head;  // Initialize current 
    while (current != NULL) 
    { 
        printf("Name: %s, Type: %d, Address: %d\n", current->st_name, current->st_type, current->address);
        current = current->next;
    } 

}
