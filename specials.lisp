;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-INTERPOL; Base: 10 -*-
;;; $Header: /home/manuel/bknr-cvs/cvs/thirdparty/cl-interpol/specials.lisp,v 1.1 2004/06/23 08:27:10 hans Exp $

;;; Copyright (c) 2003, Dr. Edmund Weitz. All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;   * Redistributions of source code must retain the above copyright
;;;     notice, this list of conditions and the following disclaimer.

;;;   * Redistributions in binary form must reproduce the above
;;;     copyright notice, this list of conditions and the following
;;;     disclaimer in the documentation and/or other materials
;;;     provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(in-package #:cl-interpol)

(defvar *list-delimiter* #\Space
  "What is inserted between the elements of a list which is
interpolated by #\@.")

(defvar *inner-delimiters* '((#\( . #\))
                             (#\{ . #\})
                             (#\< . #\>)
                             (#\[ . #\]))
  "Legal delimiters for interpolation with #\$ and #\@.")
                             
(defvar *outer-delimiters* '((#\( . #\))
                             (#\{ . #\})
                             (#\< . #\>)
                             (#\[ . #\])
                             #\/ #\| #\" #\' #\#)
  "Legal outer delimiters for CL-INTERPOL strings.")

(defvar *regex-delimiters* '(#\/)
  "Outer delimiters which automatically enable regex mode.")

(defvar *unicode-names*
  (make-hash-table :test #'equalp :size (min 14000 (+ 50 char-code-limit)))
  "A hash table which maps Unicode names to characters.")

(defvar *long-unicode-names-p* t
  "Whether long Unicode names should be tried")

(defvar *short-unicode-names-p* nil
  "Whether long Unicode names \(like \"Greek:Sigma\") should be tried")

(defvar *unicode-scripts* '("latin")
  "The Unicode scripts which are to be tried if a name couldn't be
resolved otherwise.")

(defmacro defvar-unbound (variable-name documentation)
  "Like DEFVAR, but the variable will be unbound rather than getting
an initial value.  This is useful for variables which should have no
global value but might have a dynamically bound value."
  ;; stolen from comp.lang.lisp article <k7727i3s.fsf@comcast.net> by
  ;; "prunesquallor@comcast.net"
  `(eval-when (:load-toplevel :compile-toplevel :execute)
    (defvar ,variable-name)
    (setf (documentation ',variable-name 'variable)
            ,documentation)))

(defvar-unbound *saw-backslash*
  "Whether we have to re-process an \L or \U because it closes several
scopes.")

(defvar-unbound *pair-level*
  "")

(defvar-unbound *stream*
  "Bound to the stream which is read from while parsing a string.")

(defvar-unbound *start-char*
  "Bound to the opening outer delimiter while parsing a string.")

(defvar-unbound *term-char*
  "Bound to the closing outer delimiter while parsing a string.")

(defvar *previous-readtables* nil
  "A stack which holds the previous readtables that have been pushed
here by ENABLE-INTERPOL-SYNTAX.")

(defvar-unbound *readtable-copy*
  "Bound to the current readtable if it has to be temporarily
modified.")