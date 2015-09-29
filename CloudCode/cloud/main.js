Parse.Cloud.define("runBFCode", function(u, d) {
  var l = 29999,m = new Array(l + 1),p = 0,r = "",q = [],i = 0,t = 0;
  s = u.params['code'].replace(/[^+-\[\]<>.]/, '');
  for(; i < 30000; i++) {m[i] = 0;}
  for (i=0;i<s.length;i++) {var c = s.charAt(i);
    if (c == '+') m[p] = m[p] == 254 ? 0 : m[p] + 1;
    if (c == '-') m[p] = m[p] == 0 ? 254 : m[p] - 1;
    if (c == '>') p = p == l ? 0 : p + 1;
    if (c == '<') p = p == 0 ? l : p - 1;
    if (c == '[') { 
      t = q.length; q.push(i);
      if (m[p] == 0)
        while (q.length > t) { i++;
          if (s.charAt(i) == '[') 
            q.push(i);
          if (s.charAt(i) == ']')
            q.pop();
        }
    }
    if (c == ']') i = q.pop() - 1;
    if (c == '.') r += String.fromCharCode(m[p]);
  }
  d.success(r);
});