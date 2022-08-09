if upcase(name) = 'AGE' then role = 'REJECTED';
else
if upcase(name) = 'BREAST' then role = 'REJECTED';
else
if upcase(name) = 'BREAST_QUAD' then role = 'REJECTED';
else
if upcase(name) = 'INV_NODES' then role = 'REJECTED';
else
if upcase(name) = 'MENOPAUSE' then role = 'REJECTED';
else
if upcase(name) = 'NODE_CAPS' then role = 'REJECTED';
else
if upcase(name) = 'TUMOR_SIZE' then role = 'REJECTED';
if upcase(strip(name)) = "G_TUMOR_SIZE" then level = "NOMINAL";
if upcase(strip(name)) = "G_INV_NODES" then level = "NOMINAL";
if upcase(strip(name)) = "G_AGE" then level = "NOMINAL";
if upcase(strip(name)) = "G_BREAST_QUAD" then level = "NOMINAL";
