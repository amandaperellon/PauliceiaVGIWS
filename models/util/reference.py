#!/usr/bin/env python
# -*- coding: utf-8 -*-


def get_subquery_reference_table(**kwargs):
    # DEFAULT WHERE
    conditions_of_where = []

    # conditions of WHERE CLAUSE
    if "reference_id" in kwargs and kwargs["reference_id"] is not None:
        conditions_of_where.append("reference_id = {0}".format(kwargs["reference_id"]))

    if "description" in kwargs and kwargs["description"] is not None:
        conditions_of_where.append("description = '{0}'".format(kwargs["description"]))

    if "user_id" in kwargs and kwargs["user_id"] is not None:
        conditions_of_where.append("user_id = {0}".format(kwargs["user_id"]))

    # default get all resources, without where clause
    where_clause = ""

    # if there is some conditions, put in where_clause
    if conditions_of_where:
        where_clause = "WHERE " + " AND ".join(conditions_of_where)

    # default get all resources, ordering by id
    subquery_table = """
        (
            SELECT * FROM reference {0} ORDER BY reference_id
        ) AS reference
    """.format(where_clause)

    return subquery_table
