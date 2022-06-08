#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    if (head == NULL) {
        return 0;
    }
    node *tortoise, *hare;
    tortoise = head;
    hare = head;
    while(1) {
        if (hare->next == NULL) {
            return 0;
        }
        hare = hare->next;
        if (hare->next == NULL) {
            return 0;
        }
        hare = hare->next;
        if (tortoise->next == NULL) {
            return 0;
        }
        tortoise = tortoise->next;
        if (tortoise == hare) {
            return 1;
        }
    }

    return 888;
}