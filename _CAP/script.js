// 2 - error handling
// error: 
const payCustomers = customers => {
 try {
 customers.forEach(c => { c.payments.paid = true })
 } catch (e) {
 console.error("Some error happened:", e)
 }
}
//  fix: 
const payCustomers = customers =>
 customers.forEach(c => {
 if (c.payments) c.payments.paid = true
 })

 const payCustomers = customers =>
 Array.isArray(customers) &&
 customers.forEach(c => {
 if (c && c.payments) c.payments.paid = true
 })
//Always handle operational errors
 app.get('/Books', async (_, res) => {
    try {
    const httpResponse = await executeHttpRequest(...)
    res.send(httpResponse)
    } catch (e) {
    console.error(e)
    res.sendStatus(502) // Bad Gateway
    }
   })
// CAP's remote service API does this automatically   
   srv.on('READ', 'Books', req => extSrv.run(req.query))