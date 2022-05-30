SELECT * FROM navires nav WHERE nav.nationalite_id NOT IN (
    SELECT nat.nationalite_id
    FROM nations nat, relations_nations rn
    WHERE (nat.nationalite_id = rn.nat_1_id OR nat.nationalite_id = rn.nat_2_id)
        AND rn.relation='GUERRE'