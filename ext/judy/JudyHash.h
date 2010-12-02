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
 * $Id: JudyHash.h,v 1.1 2002/09/06 15:23:21 lyle Exp $
 ***********************************************************************/

#ifndef JUDYHASH_H
#define JUDYHASH_H

#define HASHSIZE (1 << 8)

typedef struct JudyHash {
  Pvoid_t PJLArray[HASHSIZE];
  VALUE ifnone;
} JudyHash;

typedef struct JudyHashNode {
  VALUE key;
  VALUE value;
  struct JudyHashNode *next;
} JudyHashNode;

#define HASHARRAY(code) self->PJLArray[(code) % HASHSIZE]
#define HASHINDEX(code) (code)/HASHSIZE
#define HASHNODE(ppv) ((JudyHashNode *)(*(ppv)))
#define NEWNODE(ppv) *(ppv) = (Word_t) NewJudyHashNode()
#define HASHCODE(obj) judy_any_hash((obj))
#define EQUAL(x, y) ((x) == (y) || judy_any_cmp((x), (y)) == 0)

extern JudyHashNode *NewJudyHashNode();
extern void JudyHash_markfunc(void *ptr);
extern int judy_any_hash(VALUE obj);
extern int judy_any_cmp(VALUE a, VALUE b);
extern void JudyHash_foreach(const JudyHash *self, void (*func)(VALUE, VALUE, void *), void *arg);

#endif
