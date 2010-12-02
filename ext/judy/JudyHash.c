/***********************************************************************
 * RJudy -- the Ruby language bindings for the Judy arrays library.
 * Copyright (c) 2002 by J. Lyle Johnson. All Rights Reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * For further information please contact the author by e-mail
 * at "lyle@users.sourceforge.net".
 *
 * $Id: JudyHash.c,v 1.1 2002/09/06 15:23:21 lyle Exp $
 ***********************************************************************/

#include "Judy.h"
#include "ruby.h"
#include "rubysig.h"
#include "JudyHash.h"

JudyHashNode *NewJudyHashNode()
{
    JudyHashNode *pNode = ALLOC(JudyHashNode);
    pNode->key = Qnil;
    pNode->value = Qnil;
    pNode->next = NULL;
    return pNode;
}

/* Lifted from hash.c: rb_any_hash() */
int judy_any_hash(VALUE obj)
{
    VALUE hval;

    switch (TYPE(obj)) {
      case T_FIXNUM:
      case T_SYMBOL:
	return (int) obj;

      case T_STRING:
	return rb_str_hash(obj);

      default:
	DEFER_INTS;
	hval = rb_funcall(obj, rb_intern("hash"), 0);
	if (FIXNUM_P(hval)) {
	    hval %= 536870923;
	}
	else {
	    hval = rb_funcall(hval, '%', 1, INT2FIX(536870923));
	}
	ENABLE_INTS;
	return (int) FIX2LONG(hval);
    }
}

/* Lifted from hash.c: eql() */
static VALUE judy_eql(VALUE *args)
{
    return (VALUE) rb_eql(args[0], args[1]);
}

/* Lifted from hash.c: rb_any_cmp() */
int judy_any_cmp(VALUE a, VALUE b)
{
    VALUE args[2];
    if (FIXNUM_P(a) && FIXNUM_P(b)) {
	return a != b;
    }
    if (TYPE(a) == T_STRING && RBASIC(a)->klass == rb_cString &&
	TYPE(b) == T_STRING && RBASIC(b)->klass == rb_cString) {
	return rb_str_cmp(a, b);
    }
    if (SYMBOL_P(a) && SYMBOL_P(b)) {
	return a != b;
    }
    if (a == Qundef || b == Qundef) return -1;

    args[0] = a;
    args[1] = b;
    return !rb_with_disable_interrupt(judy_eql, (VALUE) args);
}

void JudyHash_foreach(const JudyHash *self, void (*func)(VALUE, VALUE, void *), void *arg) {
  int i;
  Word_t Index;
  Word_t *PValue;
  JudyHashNode *pNode;
  for (i = 0; i < HASHSIZE; i++) {
    Index = 0;
    JLF(PValue, self->PJLArray[i], Index);
    while (PValue) {
      for (pNode = HASHNODE(PValue); pNode; pNode = pNode->next) {
        func(pNode->key, pNode->value, arg);
      }
      JLN(PValue, self->PJLArray[i], Index);
    }
  }
}

void JudyHash_markfunc(void *ptr) {
  Word_t *PValue;
  Pvoid_t pJLArray;
  Word_t Index;
  JudyHashNode *pNode;
  int i;
  for (i = 0; i < HASHSIZE; i++) {
    pJLArray = ((JudyHash *) ptr)->PJLArray[i];
    Index = 0;
    JLF(PValue, pJLArray, Index);
    while (PValue) {
      for (pNode = HASHNODE(PValue); pNode; pNode = pNode->next) {
        rb_gc_mark(pNode->key);
        rb_gc_mark(pNode->value);
      }
      JLN(PValue, pJLArray, Index);
    }
  }
  rb_gc_mark(((JudyHash *) ptr)->ifnone);
}
